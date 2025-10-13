import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/enums/enums.dart';

import 'add_budget_event.dart';
import 'add_budget_state.dart';

class AddBudgetBloc extends Bloc<AddBudgetEvent, AddBudgetState> {
  final TransactionCategoryService _categoryService;
  final BudgetService _budgetService;

  AddBudgetBloc(this._categoryService, this._budgetService)
    : super(const AddBudgetState()) {
    on<AddBudgetEventInit>(_onInit);
    on<AddBudgetEventSetBudget>(_onSetBudget);
  }

  Future<void> _onInit(
    AddBudgetEventInit event,
    Emitter<AddBudgetState> emit,
  ) async {
    try {
      final allExpenseCategories = await _categoryService.getByType(
        TransactionType.expense,
      );
      final expenseCategories = allExpenseCategories
          .where((category) => category.isCategoryDefaultSystem)
          .toList();
      emit(state.copyWith(expenseCategories: expenseCategories));
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _onSetBudget(
    AddBudgetEventSetBudget event,
    Emitter<AddBudgetState> emit,
  ) async {
    try {
      final now = DateTime.now();
      final year = now.year;
      final month = now.month;

      if (event.itemTitle == 'Ngân sách hàng tháng') {
        await _budgetService.setMonthlyBudget(
          year: year,
          month: month,
          amount: event.amount,
        );
      } else {
        final category = state.expenseCategories.firstWhere(
          (cat) => cat.title == event.itemTitle,
          orElse: () => throw Exception('Category not found'),
        );
        await _budgetService.setBudgetForCategory(
          year: year,
          month: month,
          categoryId: category.id!,
          amount: event.amount,
        );
      }

      emit(
        state.copyWith(
          budgets: {...state.budgets, event.itemTitle: event.amount},
        ),
      );
    } catch (e) {
      emit(state);
    }
  }
}
