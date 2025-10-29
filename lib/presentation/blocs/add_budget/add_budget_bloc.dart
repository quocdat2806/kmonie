import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/enums/enums.dart';

import 'add_budget_event.dart';
import 'add_budget_state.dart';

class AddBudgetBloc extends Bloc<AddBudgetEvent, AddBudgetState> {
  final TransactionCategoryRepository _categoryRepository;
  final BudgetRepository _budgetRepository;

  AddBudgetBloc(this._categoryRepository, this._budgetRepository) : super(const AddBudgetState()) {
    on<AddBudgetEventInit>(_onInit);
    on<AddBudgetEventSetBudget>(_onSetBudget);
    on<AddBudgetEventResetInput>(_onResetInput);
    on<AddBudgetEventInputKey>(_onInputKey);
  }

  Future<void> _onInit(AddBudgetEventInit event, Emitter<AddBudgetState> emit) async {
    try {
      final result = await _categoryRepository.getByType(TransactionType.expense);
      result.fold((failure) => logger.e(failure.message), (allExpenseCategories) => emit(state.copyWith(expenseCategories: allExpenseCategories)));
    } catch (e) {
      logger.e(e);
    }
  }

  void _onResetInput(AddBudgetEventResetInput event, Emitter<AddBudgetState> emit) {
    emit(state.copyWith(currentInput: 0));
  }

  void _onInputKey(AddBudgetEventInputKey event, Emitter<AddBudgetState> emit) {
    final key = event.key;
    if (key == 'DONE') {
      return; // handled by UI caller to dispatch setBudget with currentInput
    }
    if (key == 'CLEAR') {
      emit(state.copyWith(currentInput: state.currentInput ~/ 10));
      return;
    }
    if (RegExp(r'^\d+$').hasMatch(key)) {
      final digit = int.tryParse(key) ?? 0;
      emit(state.copyWith(currentInput: state.currentInput * 10 + digit));
    }
  }

  Future<void> _onSetBudget(AddBudgetEventSetBudget event, Emitter<AddBudgetState> emit) async {
    try {
      final now = DateTime.now();
      final year = now.year;
      final month = now.month;

      if (event.itemTitle == 'Ngân sách hàng tháng') {
        final res = await _budgetRepository.setMonthlyBudget(year: year, month: month, amount: event.amount);
        res.fold((failure) => logger.e(failure.message), (_) {});
      } else {
        final category = state.expenseCategories.firstWhere((cat) => cat.title == event.itemTitle, orElse: () => throw Exception('Category not found'));
        final res = await _budgetRepository.setBudgetForCategory(year: year, month: month, categoryId: category.id!, amount: event.amount);
        res.fold((failure) => logger.e(failure.message), (_) {});
      }

      emit(state.copyWith(budgets: {...state.budgets, event.itemTitle: event.amount}));
      AppStreamEvent.budgetChangedStatic();
    } catch (e) {
      emit(state);
    }
  }
}
