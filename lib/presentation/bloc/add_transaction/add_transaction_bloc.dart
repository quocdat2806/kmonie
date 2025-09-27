import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/enum/exports.dart';
import '../../../core/service/exports.dart';
import '../../../entity/exports.dart';
import 'add_transaction_event.dart';
import 'add_transaction_state.dart';

class AddTransactionBloc
    extends Bloc<AddTransactionEvent, AddTransactionState> {
  final TransactionCategoryService service;

  AddTransactionBloc(this.service) : super(const AddTransactionState()) {
    on<AddTransactionSwitchTab>(_onSwitchTab);
    on<AddTransactionLoadCategories>(_onLoadCategories);
    on<AddTransactionCategoryChanged>(_onCategoryChanged);
    on<AddTransactionToggleKeyboardVisibility>(
          (e, emit) => emit(state.copyWith(isKeyboardVisible: !state.isKeyboardVisible)),
    );

    add(AddTransactionLoadCategories(state.currentType));
  }

  Future<void> _onSwitchTab(
      AddTransactionSwitchTab e,
      Emitter<AddTransactionState> emit,
      ) async {
    if (e.index == state.selectedIndex) return;

    final newType = TransactionType.fromIndex(e.index);
    emit(state.copyWith(selectedIndex: e.index));

    if (!state.categoriesByType.containsKey(newType)) {
      add(AddTransactionLoadCategories(newType));
    }
  }

  Future<void> _onLoadCategories(
      AddTransactionLoadCategories e,
      Emitter<AddTransactionState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));
    final list = await service.getByType(e.type);
    final updated = Map<TransactionType, List<TransactionCategory>>.from(state.categoriesByType)
      ..[e.type] = list;
    emit(state.copyWith(isLoading: false, categoriesByType: updated));
  }

  void _onCategoryChanged(
      AddTransactionCategoryChanged e,
      Emitter<AddTransactionState> emit,
      ) {
    final next = Map<TransactionType, int?>.from(state.selectedCategoryIdByType)
      ..[e.type] = e.categoryId;

    if (!state.isKeyboardVisible) {
      add(const AddTransactionToggleKeyboardVisibility());
    }
    emit(state.copyWith(selectedCategoryIdByType: next));
  }
}
