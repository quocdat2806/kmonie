import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/export.dart';
import '../../../core/service/export.dart';
import '../../../entity/export.dart';
import 'add_transaction_event.dart';
import 'add_transaction_state.dart';

class AddTransactionBloc extends Bloc<AddTransactionEvent, AddTransactionState> {
  final TransactionCategoryService service;
  final TransactionService transactionService;

  AddTransactionBloc(this.service, this.transactionService) : super(const AddTransactionState()) {
    on<SwitchTab>(_onSwitchTab);
    on<LoadCategories>(_onLoadCategories);
    on<CategoryChanged>(_onCategoryChanged);
    on<ToggleKeyboardVisibility>(_onKeyboardVisibilityChanged);
    on<AmountChanged>(_onAmountChanged);
    on<NoteChanged>(_onNoteChanged);
    on<SaveTransaction>(_onSaveTransaction);
    add(LoadCategories(state.currentType));
  }
  void _onKeyboardVisibilityChanged(ToggleKeyboardVisibility e, Emitter<AddTransactionState> emit) {
    emit(state.copyWith(isKeyboardVisible: !state.isKeyboardVisible));
  }

  void _onAmountChanged(AmountChanged e, Emitter<AddTransactionState> emit) {
    final String value = e.value;

    if (value == 'DONE') {
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
