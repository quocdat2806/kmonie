import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/repositories/repositories.dart';

import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final TransactionCategoryRepository _categoryRepository;
  final BudgetRepository _budgetRepository;
  StreamSubscription<AppStreamData>? _refreshSubscription;

  BudgetBloc(this._categoryRepository, this._budgetRepository)
    : super(const BudgetState()) {
    on<BudgetEventInit>(_onInit);
    on<BudgetEventChangePeriod>(_onChangePeriod);

    _refreshSubscription = AppStreamEvent.eventStreamStatic.listen((data) {
      if (data.event == AppEvent.budgetChanged) {
        final p = state.period ?? DateTime.now();
        add(BudgetEvent.changePeriod(period: DateTime(p.year, p.month)));
      }
    });
    add(
      BudgetEventInit(
        period: DateTime(DateTime.now().year, DateTime.now().month),
      ),
    );
  }

  Future<void> _onInit(BudgetEventInit event, Emitter<BudgetState> emit) async {
    try {
      await _loadBudgetData(event.period, emit);
    } catch (e) {
      logger.e('Error in BudgetBloc _onInit: $e');
    }
  }

  Future<void> _onChangePeriod(
    BudgetEventChangePeriod event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      await _loadBudgetData(event.period, emit);
    } catch (e) {
      logger.e('Error in BudgetBloc _onInit: $e');
    }
  }

  Future<void> _loadBudgetData(
    DateTime period,
    Emitter<BudgetState> emit,
  ) async {
    final year = period.year;
    final month = period.month;

    final categoriesEither = await _categoryRepository.getByType(
      TransactionType.expense,
    );
    final allExpenseCategories = categoriesEither.fold(
      (_) => <TransactionCategory>[],
      (list) => list,
    );
    final expenseCategories = allExpenseCategories
        .where((category) => category.title != 'Cài đặt')
        .toList();

    final monthlyBudget = (await _budgetRepository.getMonthlyBudget(
      year: year,
      month: month,
    )).fold((_) => 0, (v) => v);

    final totalSpent = (await _budgetRepository.getTotalSpentForMonth(
      year: year,
      month: month,
    )).fold((_) => 0, (v) => v);

    final Map<int, int> categoryBudgets = {};
    final Map<int, int> categorySpent = {};

    for (final category in expenseCategories) {
      final budget = (await _budgetRepository.getBudgetForCategory(
        year: year,
        month: month,
        categoryId: category.id!,
      )).fold((_) => 0, (v) => v);
      final spent = (await _budgetRepository.getSpentForCategory(
        year: year,
        month: month,
        categoryId: category.id!,
      )).fold((_) => 0, (v) => v);

      categoryBudgets[category.id!] = budget;
      categorySpent[category.id!] = spent;
    }

    emit(
      state.copyWith(
        expenseCategories: expenseCategories,
        categoryBudgets: categoryBudgets,
        monthlyBudget: monthlyBudget,
        totalSpent: totalSpent,
        categorySpent: categorySpent,
        period: period,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _refreshSubscription?.cancel();
    return super.close();
  }
}
