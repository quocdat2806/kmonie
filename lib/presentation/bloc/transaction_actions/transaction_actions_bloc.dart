import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/export.dart';
import '../../../core/service/export.dart';
import '../../../core/stream/export.dart';
import '../../../entity/export.dart';
import '../../pages/export.dart';
import 'transaction_actions_event.dart';
import 'transaction_actions_state.dart';

class TransactionActionsBloc extends Bloc<TransactionActionsEvent, TransactionActionsState> {
  final TransactionCategoryService categoryService;
  final TransactionService transactionService;
  final TransactionActionsPageArgs? args;

  TransactionActionsBloc(this.categoryService, this.transactionService, this.args) : super(const TransactionActionsState()) {
    on<Initialize>(_onInitialize);
    on<SwitchTab>(_onSwitchTab);
    on<LoadCategories>(_onLoadCategories);
    on<CategoryChanged>(_onCategoryChanged);
    on<ToggleKeyboardVisibility>(_onKeyboardVisibilityChanged);
    on<AmountChanged>(_onAmountChanged);
    on<NoteChanged>(_onNoteChanged);
    on<SubmitTransaction>(_onSubmitTransaction);
    on<SaveTransaction>(_onSaveTransaction);

    add(const Initialize());
  }

  Future<void> _onInitialize(Initialize e, Emitter<TransactionActionsState> emit) async {
    if (args != null && args!.mode == TransactionActionsMode.edit) {
      final tx = args!.transaction!;
      final type = TransactionType.fromIndex(tx.transactionType);
      add(LoadCategories(type));
      emit(state.copyWith(selectedIndex: tx.transactionType, note: tx.content, amount: tx.amount, selectedCategoryIdByType: {type: tx.transactionCategoryId}));
      add(ToggleKeyboardVisibility());
    } else {
      add(LoadCategories(state.currentType));
    }
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

  Future<void> _onSwitchTab(SwitchTab e, Emitter<TransactionActionsState> emit) async {
    if (e.index == state.selectedIndex) return;
    final newType = TransactionType.fromIndex(e.index);
    emit(state.copyWith(selectedIndex: e.index));

    if (!state.categoriesByType.containsKey(newType)) {
      add(LoadCategories(newType));
    }
  }

  Future<void> _onLoadCategories(LoadCategories e, Emitter<TransactionActionsState> emit) async {
    try {
      final list = await categoryService.getByType(e.type);
      final updated = Map<TransactionType, List<TransactionCategory>>.from(state.categoriesByType)..[e.type] = list;
      emit(state.copyWith(categoriesByType: updated));
    } catch (_) {
      emit(state.copyWith(loadStatus: LoadStatus.error));
    }
  }

  void _onCategoryChanged(CategoryChanged e, Emitter<TransactionActionsState> emit) {
    final next = Map<TransactionType, int?>.from(state.selectedCategoryIdByType)..[e.type] = e.categoryId;
    emit(state.copyWith(selectedCategoryIdByType: next));

    if (!state.isKeyboardVisible) add(const ToggleKeyboardVisibility());
  }

  Future<void> _onSubmitTransaction(SubmitTransaction e, Emitter<TransactionActionsState> emit) async {
    add(const ToggleKeyboardVisibility());

    if (args != null && args!.mode == TransactionActionsMode.edit) {
      await _updateExistingTransaction();
      emit(state.copyWith(loadStatus: LoadStatus.success));
      return;
    }
    add(const SaveTransaction());
  }

  Future<void> _onSaveTransaction(SaveTransaction e, Emitter<TransactionActionsState> emit) async {
    if (state.amount <= 0) {
      emit(state.copyWith(loadStatus: LoadStatus.error));
      return;
    }

    final categoryId = state.selectedCategoryIdFor(state.currentType);
    if (categoryId == null) {
      emit(state.copyWith(loadStatus: LoadStatus.error));
      return;
    }

    try {
      final newTx = await transactionService.createTransaction(amount: state.amount, date: state.date ?? DateTime.now(), transactionCategoryId: categoryId, content: state.note, transactionType: state.currentType.typeIndex);
      AppStreamEvent.insertTransactionStatic(newTx);
      emit(state.copyWith(loadStatus: LoadStatus.success));
    } catch (_) {
      emit(state.copyWith(loadStatus: LoadStatus.error));
    }
  }

  Future<void> _updateExistingTransaction() async {
    final tx = args!.transaction!;
    final updatedTx = await transactionService.updateTransaction(id: tx.id!, amount: state.amount, content: state.note, date: tx.date, transactionCategoryId: state.selectedCategoryIdFor(state.currentType));
    if (updatedTx != null) {
      AppStreamEvent.updateTransactionStatic(updatedTx);
    }
  }
}
