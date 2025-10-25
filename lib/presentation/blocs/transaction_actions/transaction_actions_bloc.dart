import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/presentation/pages/pages.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'transaction_actions_event.dart';
import 'transaction_actions_state.dart';

class TransactionActionsBloc extends Bloc<TransactionActionsEvent, TransactionActionsState> {
  final TransactionCategoryRepository categoryRepository;
  final TransactionRepository transactionRepository;
  final TransactionActionsPageArgs? args;

  TransactionActionsBloc(this.categoryRepository, this.transactionRepository, this.args) : super(const TransactionActionsState()) {
    on<Initialize>(_onInitialize);
    on<SwitchTab>(_onSwitchTab);
    on<CategoryChanged>(_onCategoryChanged);
    on<ToggleKeyboardVisibility>(_onKeyboardVisibilityChanged);
    on<AmountChanged>(_onAmountChanged);
    on<NoteChanged>(_onNoteChanged);
    on<SubmitTransaction>(_onSubmitTransaction);
    on<SelectDateChange>(_onSelectDateChange);
    on<RequestSelectDate>(_onRequestSelectDate);
    on<CheckOverBudget>(_onCheckOverBudget);
    on<ClearSelectDateState>(_onClearSelectDateState);
    on<ClearOverBudgetState>(_onClearOverBudgetState);
    on<SetShouldScroll>(_onSetShouldScroll);
    on<SetHasScrolledOnce>(_onSetHasScrolledOnce);
    on<ResetScrollState>(_onResetScrollState);
    on<UpdateKeyboardHeight>(_onUpdateKeyboardHeight);
    add(const Initialize());
  }
  void _onSelectDateChange(SelectDateChange e, Emitter<TransactionActionsState> emit) {
    emit(state.copyWith(date: e.date));
  }

  Future<void> _onInitialize(Initialize e, Emitter<TransactionActionsState> emit) async {
    final categoriesResult = await categoryRepository.getAll();

    await categoriesResult.fold(
      (failure) async {
        emit(state.copyWith(loadStatus: LoadStatus.error));
        return;
      },
      (categories) async {
        final separated = _separateCategories(categories);
        emit(state.copyWith(separatedCategories: separated));
      },
    );

    if (args != null && args!.mode == ActionsMode.edit) {
      final tx = args!.transaction!;
      final type = TransactionType.fromIndex(tx.transactionType);
      emit(state.copyWith(selectedIndex: type.index, isKeyboardVisible: true, date: tx.date, note: tx.content, amount: tx.amount, selectedCategoryIdByType: {type: tx.transactionCategoryId}));
      return;
    }

    final initialDate = args?.selectedDate ?? DateTime.now();
    emit(state.copyWith(date: initialDate));
  }

  void _onKeyboardVisibilityChanged(ToggleKeyboardVisibility e, Emitter<TransactionActionsState> emit) {
    emit(state.copyWith(isKeyboardVisible: !state.isKeyboardVisible));
  }

  void _onAmountChanged(AmountChanged e, Emitter<TransactionActionsState> emit) {
    final value = e.value;

    if (value == '+' || value == '-') return;

    int newAmount = state.amount;

    if (value == 'CLEAR') {
      final str = newAmount.toString();
      newAmount = str.length > 1 ? int.parse(str.substring(0, str.length - 1)) : 0;
      emit(state.copyWith(amount: newAmount));
      return;
    }

    final parsed = int.tryParse(value);
    if (parsed == null) return;

    final newStr = newAmount == 0 ? value : '$newAmount$value';
    newAmount = int.parse(newStr);
    emit(state.copyWith(amount: newAmount));
  }

  void _onNoteChanged(NoteChanged e, Emitter<TransactionActionsState> emit) {
    emit(state.copyWith(note: e.value));
  }

  void _onSwitchTab(SwitchTab e, Emitter<TransactionActionsState> emit) {
    if (e.index == state.selectedIndex) return;
    emit(state.copyWith(selectedIndex: e.index));
  }

  void _onCategoryChanged(CategoryChanged e, Emitter<TransactionActionsState> emit) {
    final next = Map<TransactionType, int?>.from(state.selectedCategoryIdByType)..[e.type] = e.categoryId;
    emit(state.copyWith(selectedCategoryIdByType: next));

    if (!state.isKeyboardVisible) add(const ToggleKeyboardVisibility());
  }

  Future<void> _onSubmitTransaction(SubmitTransaction e, Emitter<TransactionActionsState> emit) async {
    add(const ToggleKeyboardVisibility());

    if (args != null && args!.mode == ActionsMode.edit) {
      await _updateExistingTransaction();
      emit(state.copyWith(loadStatus: LoadStatus.success));
      return;
    }
    if (state.amount <= 0) {
      emit(state.copyWith(loadStatus: LoadStatus.error));
      return;
    }

    final categoryId = state.selectedCategoryIdFor(state.currentType);
    if (categoryId == null) {
      emit(state.copyWith(loadStatus: LoadStatus.error));
      return;
    }

    final createResult = await transactionRepository.createTransaction(amount: state.amount, date: state.date ?? DateTime.now(), transactionCategoryId: categoryId, content: state.note, transactionType: state.currentType.typeIndex);

    createResult.fold((failure) => emit(state.copyWith(loadStatus: LoadStatus.error)), (newTx) {
      AppStreamEvent.insertTransactionStatic(newTx);
      emit(state.copyWith(loadStatus: LoadStatus.success));
    });
  }

  Future<void> _updateExistingTransaction() async {
    final tx = args!.transaction!;
    final updateResult = await transactionRepository.updateTransaction(id: tx.id!, amount: state.amount, content: state.note, date: state.date ?? tx.date, transactionCategoryId: state.selectedCategoryIdFor(state.currentType));

    updateResult.fold(
      (failure) => null, // Handle error if needed
      (updatedTx) {
        if (updatedTx != null) {
          AppStreamEvent.updateTransactionStatic(updatedTx);
        }
      },
    );
  }

  SeparatedCategories _separateCategories(List<TransactionCategory> all) {
    final expense = <TransactionCategory>[];
    final income = <TransactionCategory>[];
    final transfer = <TransactionCategory>[];

    for (final e in all) {
      switch (e.transactionType) {
        case TransactionType.expense:
          expense.add(e);
          break;
        case TransactionType.income:
          income.add(e);
          break;
        case TransactionType.transfer:
          transfer.add(e);
          break;
      }
    }

    return SeparatedCategories(expense: expense, income: income, transfer: transfer);
  }

  void _onRequestSelectDate(RequestSelectDate e, Emitter<TransactionActionsState> emit) {
    emit(state.copyWith(selectDateState: SelectDateState.showDatePicker));
  }

  Future<void> _onCheckOverBudget(CheckOverBudget e, Emitter<TransactionActionsState> emit) async {
    final categoryId = state.selectedCategoryIdFor(state.currentType);
    if (categoryId == null || state.amount <= 0) {
      add(const SubmitTransaction());
      return;
    }

    final date = state.date ?? DateTime.now();
    final year = date.year;
    final month = date.month;

    try {
      final budgetResult = await sl<BudgetRepository>().getBudgetForCategory(year: year, month: month, categoryId: categoryId);
      final budgetAmount = budgetResult.fold((failure) => 0, (budget) => budget);

      if (budgetAmount <= 0) {
        add(const SubmitTransaction());
        return;
      }

      final allResult = await transactionRepository.getAllTransactions();
      final all = allResult.fold((failure) => <Transaction>[], (transactions) => transactions);

      final range = AppDateUtils.monthRangeUtc(year, month);
      final startLocal = range.startUtc.toLocal();
      final endLocal = range.endUtc.toLocal();

      final spentSoFar = all.where((t) => t.transactionCategoryId == categoryId && t.transactionType == TransactionType.expense.typeIndex && !t.date.isBefore(startLocal) && t.date.isBefore(endLocal)).fold<int>(0, (p, t) => p + t.amount);

      final proposed = spentSoFar + state.amount;

      if (proposed > budgetAmount) {
        emit(state.copyWith(overBudgetState: OverBudgetState.showOverBudgetDialog));
      } else {
        add(const SubmitTransaction());
      }
    } catch (e) {
      add(const SubmitTransaction());
    }
  }

  void _onClearSelectDateState(ClearSelectDateState e, Emitter<TransactionActionsState> emit) {
    emit(state.copyWith(selectDateState: SelectDateState.none));
  }

  void _onClearOverBudgetState(ClearOverBudgetState e, Emitter<TransactionActionsState> emit) {
    emit(state.copyWith(overBudgetState: OverBudgetState.none));
  }

  void _onSetShouldScroll(SetShouldScroll e, Emitter<TransactionActionsState> emit) {
    emit(state.copyWith(shouldScroll: e.shouldScroll));
  }

  void _onSetHasScrolledOnce(SetHasScrolledOnce e, Emitter<TransactionActionsState> emit) {
    emit(state.copyWith(hasScrolledOnce: e.hasScrolledOnce));
  }

  void _onResetScrollState(ResetScrollState e, Emitter<TransactionActionsState> emit) {
    emit(state.copyWith(shouldScroll: false, hasScrolledOnce: false));
  }

  void _onUpdateKeyboardHeight(UpdateKeyboardHeight e, Emitter<TransactionActionsState> emit) {
    emit(state.copyWith(previousKeyboardHeight: e.height));
  }
}
