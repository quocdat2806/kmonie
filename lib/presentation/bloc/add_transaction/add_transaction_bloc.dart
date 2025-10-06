import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/export.dart';
import '../../../core/service/export.dart';
import '../../../core/stream/app_stream_service.dart';
import '../../../entity/export.dart';
import '../../pages/transaction_action/transaction_actions_page.dart';
import 'add_transaction_event.dart';
import 'add_transaction_state.dart';

class AddTransactionBloc extends Bloc<AddTransactionEvent, AddTransactionState> {
  final TransactionCategoryService service;
  final TransactionService transactionService;
  final TransactionActionsPageArgs?args;

  AddTransactionBloc(this.service, this.transactionService,this.args) : super(const AddTransactionState()) {
    on<SwitchTab>(_onSwitchTab);
    on<LoadCategories>(_onLoadCategories);
    on<CategoryChanged>(_onCategoryChanged);
    on<ToggleKeyboardVisibility>(_onKeyboardVisibilityChanged);
    on<AmountChanged>(_onAmountChanged);
    on<NoteChanged>(_onNoteChanged);
    on<SaveTransaction>(_onSaveTransaction);
    if(args!=null &&args!.mode == TransactionActionsMode.edit){
      add(LoadCategories(TransactionType.fromIndex(args!.transaction!.transactionType)));
      add(SwitchTab(
          args!.transaction!.transactionType
      ));
      add(CategoryChanged(
        type: TransactionType.fromIndex(args!.transaction!.transactionType),
        categoryId: args!.transaction!.transactionCategoryId
      ));
      add(AmountChanged(args!.transaction!.amount.toString()));
      add(NoteChanged(args!.transaction!.content.toString()));
      return;
    }
    add(LoadCategories(state.currentType));
  }
  void _onKeyboardVisibilityChanged(ToggleKeyboardVisibility e, Emitter<AddTransactionState> emit) {
    emit(state.copyWith(isKeyboardVisible: !state.isKeyboardVisible));
  }

  void _onAmountChanged(AmountChanged e, Emitter<AddTransactionState> emit) {
    final String value = e.value;

    if (value == 'DONE') {
      if(args!=null &&args!.mode == TransactionActionsMode.edit){
        add(const ToggleKeyboardVisibility());
        _updateExistingTransaction();
        emit(state.copyWith(loadStatus: LoadStatus.success));
        return;
      }
      add(const ToggleKeyboardVisibility());
      add(const SaveTransaction());
      return;
    }

    if (value == '+' || value == '-') {
      return;
    }

    int newAmount = state.amount;

    if (value == 'CLEAR') {
      final amountStr = newAmount.toString();
      if (amountStr.length > 1) {
        newAmount = int.parse(amountStr.substring(0, amountStr.length - 1));
      } else {
        newAmount = 0;
      }
      emit(state.copyWith(amount: newAmount));
      return;
    }

    final parsedValue = int.tryParse(value);
    if (parsedValue == null) return;

    final currentAmountStr = newAmount.toString();
    final newAmountStr = currentAmountStr + value;
    newAmount = int.parse(newAmountStr);
    emit(state.copyWith(amount: newAmount));
  }

  Future<void> _updateExistingTransaction() async {
    final transaction = args!.transaction!;
   await transactionService.updateTransaction(
      id: transaction.id!,
      amount: state.amount,
      content: state.note,
      date: transaction.date,
      transactionCategoryId: state.selectedCategoryIdFor(state.currentType),
    );


  }

  void _onNoteChanged(NoteChanged e, Emitter<AddTransactionState> emit) {
    emit(state.copyWith(note: e.value));
  }

  Future<void> _onSwitchTab(SwitchTab e, Emitter<AddTransactionState> emit) async {
    if (e.index == state.selectedIndex) return;

    final newType = TransactionType.fromIndex(e.index);
    emit(state.copyWith(selectedIndex: e.index));

    if (!state.categoriesByType.containsKey(newType)) {
      add(LoadCategories(newType));
    }
  }

  Future<void> _onLoadCategories(LoadCategories e, Emitter<AddTransactionState> emit) async {
    try {
      final list = await service.getByType(e.type);
      final updated = Map<TransactionType, List<TransactionCategory>>.from(state.categoriesByType)..[e.type] = list;
      emit(state.copyWith(categoriesByType: updated));
    } catch (error) {
      emit(state.copyWith(loadStatus: LoadStatus.error));
    }
  }

  void _onCategoryChanged(CategoryChanged e, Emitter<AddTransactionState> emit) {
    final next = Map<TransactionType, int?>.from(state.selectedCategoryIdByType)..[e.type] = e.categoryId;

    emit(state.copyWith(selectedCategoryIdByType: next));

    if (!state.isKeyboardVisible) {
      add(const ToggleKeyboardVisibility());
    }
  }

  Future<void> _onSaveTransaction(SaveTransaction e, Emitter<AddTransactionState> emit) async {
    if (state.amount <= 0) {
      emit(state.copyWith(loadStatus: LoadStatus.error));
      return;
    }
    final selectedCategoryId = state.selectedCategoryIdFor(state.currentType);
    if (selectedCategoryId == null) {
      emit(state.copyWith(loadStatus: LoadStatus.error));
      return;
    }
    try {
      await transactionService.createTransaction(amount: state.amount, date: state.date ?? DateTime.now(), transactionCategoryId: selectedCategoryId, content: state.note, transactionType: state.currentType.typeIndex);
      emit(state.copyWith(loadStatus: LoadStatus.success));
    } catch (error) {
      emit(state.copyWith(loadStatus: LoadStatus.error));
    }
  }
}
