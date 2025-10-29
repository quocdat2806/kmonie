import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/utils/utils.dart';

import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final TransactionCategoryRepository _categoryRepository;
  final BudgetRepository _budgetRepository;
  StreamSubscription<AppStreamData>? _refreshSubscription;

  BudgetBloc(this._categoryRepository, this._budgetRepository) : super(const BudgetState()) {
    on<BudgetEventInit>(_onInit);
    on<BudgetEventChangePeriod>(_onChangePeriod);
    on<BudgetEventSetBudget>(_onSetBudget);
    on<BudgetEventResetInput>(_onResetInput);
    on<BudgetEventInputKey>(_onInputKey);
    on<BudgetEventSetSelectedPeriod>(_onSetSelectedPeriod);

    _refreshSubscription = AppStreamEvent.eventStreamStatic.listen((data) {
      if (data.event == AppEvent.budgetChanged) {
        final p = state.selectedPeriod ?? state.period ?? DateTime.now();
        add(BudgetEvent.changePeriod(period: DateTime(p.year, p.month)));
      }
    });
  }

  Future<void> _onInit(BudgetEventInit event, Emitter<BudgetState> emit) async {
    try {
      await _loadBudgetData(event.period, emit);
    } catch (e) {
      logger.e('Error in BudgetBloc _onInit: $e');
    }
  }

  Future<void> _onChangePeriod(BudgetEventChangePeriod event, Emitter<BudgetState> emit) async {
    try {
      await _loadBudgetData(event.period, emit);
    } catch (e) {
      logger.e('Error in BudgetBloc _onInit: $e');
    }
  }

  Future<void> _onSetBudget(BudgetEventSetBudget event, Emitter<BudgetState> emit) async {
    try {
      final res = await _budgetRepository.setBudgetForCategory(year: event.period.year, month: event.period.month, categoryId: event.categoryId, amount: event.amount);
      res.fold((failure) => logger.e(failure.message), (_) {});

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
    final categoriesEither = await _categoryRepository.getByType(TransactionType.expense);
    final allExpenseCategories = categoriesEither.fold((_) => <TransactionCategory>[], (list) => list);
    final expenseCategories = allExpenseCategories.where((category) => category.title != 'Cài đặt').toList();

    // Load monthly budget
    final monthlyBudget = (await _budgetRepository.getMonthlyBudget(year: year, month: month)).fold((_) => 0, (v) => v);

    // Load total spent
    final totalSpent = (await _budgetRepository.getTotalSpentForMonth(year: year, month: month)).fold((_) => 0, (v) => v);

    // Load category budgets and spent amounts
    final Map<int, int> categoryBudgets = {};
    final Map<int, int> categorySpent = {};

    for (final category in expenseCategories) {
      final budget = (await _budgetRepository.getBudgetForCategory(year: year, month: month, categoryId: category.id!)).fold((_) => 0, (v) => v);
      final spent = (await _budgetRepository.getSpentForCategory(year: year, month: month, categoryId: category.id!)).fold((_) => 0, (v) => v);

      categoryBudgets[category.id!] = budget;
      categorySpent[category.id!] = spent;
    }

    emit(state.copyWith(expenseCategories: expenseCategories, categoryBudgets: categoryBudgets, monthlyBudget: monthlyBudget, totalSpent: totalSpent, categorySpent: categorySpent, period: period, selectedPeriod: period));
  }

  void _onResetInput(BudgetEventResetInput event, Emitter<BudgetState> emit) {
    emit(state.copyWith(currentInput: 0));
  }

  void _onInputKey(BudgetEventInputKey event, Emitter<BudgetState> emit) {
    final key = event.key;
    if (key == 'DONE') return; // handled by UI
    if (key == 'CLEAR') {
      emit(state.copyWith(currentInput: state.currentInput ~/ 10));
      return;
    }
    if (RegExp(r'^\d+$').hasMatch(key)) {
      final digit = int.tryParse(key) ?? 0;
      emit(state.copyWith(currentInput: state.currentInput * 10 + digit));
    }
  }

  void _onSetSelectedPeriod(BudgetEventSetSelectedPeriod event, Emitter<BudgetState> emit) {
    emit(state.copyWith(selectedPeriod: DateTime(event.period.year, event.period.month)));
  }

  @override
  Future<void> close() async {
    await _refreshSubscription?.cancel();
    return super.close();
  }
}
