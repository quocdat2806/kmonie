import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/services/transaction_category.dart';
import 'package:kmonie/core/services/budget.dart';
import 'package:kmonie/core/enums/enums.dart';

import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final TransactionCategoryService _categoryService;
  final BudgetService _budgetService;

  BudgetBloc(this._categoryService, this._budgetService) : super(const BudgetState()) {
    on<BudgetEventInit>(_onInit);
    on<BudgetEventChangePeriod>(_onChangePeriod);
    on<BudgetEventSetBudget>(_onSetBudget);
  }

  Future<void> _onInit(BudgetEventInit event, Emitter<BudgetState> emit) async {
    try {
      await _loadBudgetData(event.period, emit);
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<void> _onChangePeriod(BudgetEventChangePeriod event, Emitter<BudgetState> emit) async {
    try {
      await _loadBudgetData(event.period, emit);
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<void> _onSetBudget(BudgetEventSetBudget event, Emitter<BudgetState> emit) async {
    try {
      await _budgetService.setBudgetForCategory(year: event.period.year, month: event.period.month, categoryId: event.categoryId, amount: event.amount);

      // Reload data after setting budget
      await _loadBudgetData(event.period, emit);
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<void> _loadBudgetData(DateTime period, Emitter<BudgetState> emit) async {
    final year = period.year;
    final month = period.month;

    // Load expense categories (filter out "Cài đặt" category)
    final allExpenseCategories = await _categoryService.getByType(TransactionType.expense);
    final expenseCategories = allExpenseCategories.where((category) => category.title != 'Cài đặt').toList();

    // Load monthly budget
    final monthlyBudget = await _budgetService.getMonthlyBudget(year: year, month: month);

    // Load total spent
    final totalSpent = await _budgetService.getTotalSpentForMonth(year: year, month: month);

    // Load category budgets and spent amounts
    final Map<int, int> categoryBudgets = {};
    final Map<int, int> categorySpent = {};

    for (final category in expenseCategories) {
      final budget = await _budgetService.getBudgetForCategory(year: year, month: month, categoryId: category.id!);
      final spent = await _budgetService.getSpentForCategory(year: year, month: month, categoryId: category.id!);

      categoryBudgets[category.id!] = budget;
      categorySpent[category.id!] = spent;
    }

    emit(state.copyWith(expenseCategories: expenseCategories, categoryBudgets: categoryBudgets, monthlyBudget: monthlyBudget, totalSpent: totalSpent, categorySpent: categorySpent, period: period));
  }
}
