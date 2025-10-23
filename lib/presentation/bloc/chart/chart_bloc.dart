import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'package:kmonie/presentation/widgets/chart/app_chart.dart';
import 'chart_event.dart';
import 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final TransactionService transactionService;
  final TransactionCategoryService categoryService;
  StreamSubscription<AppStreamData>? _subscription;

  ChartBloc(this.transactionService, this.categoryService) : super(const ChartState()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<ChangeTransactionType>(_onChangeTransactionType);
    on<ChangePeriodType>(_onChangePeriodType);
    on<SelectMonth>(_onSelectMonth);
    on<SelectYear>(_onSelectYear);
    on<LoadMoreMonths>(_onLoadMoreMonths);
    on<LoadMoreYears>(_onLoadMoreYears);
    on<RefreshChart>(_onRefreshChart);
    on<AddTransactionLocal>(_onAddTransactionLocal);
    on<UpdateTransactionLocal>(_onUpdateTransactionLocal);
    on<DeleteTransactionLocal>(_onDeleteTransactionLocal);

    _subscription = AppStreamEvent.eventStreamStatic.listen((data) {
      switch (data.event) {
        case AppEvent.insertTransaction:
          if (data.payload is Transaction) {
            final transaction = data.payload as Transaction;
            if (_isTransactionInCurrentPeriod(transaction)) {
              add(AddTransactionLocal(transaction));
            }
          }
          break;
        case AppEvent.updateTransaction:
          if (data.payload is Transaction) {
            final transaction = data.payload as Transaction;
            add(UpdateTransactionLocal(transaction));
          }
          break;
        case AppEvent.deleteTransaction:
          if (data.payload is int) {
            final transactionId = data.payload as int;
            // For delete, we need to check if the deleted transaction was in our local state
            final hasTransaction = state.localTransactions.any((t) => t.id == transactionId);
            if (hasTransaction) {
              add(DeleteTransactionLocal(transactionId));
            }
          }
          break;
        default:
          break;
      }
    });

    add(const LoadInitialData());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadInitialData(LoadInitialData event, Emitter<ChartState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final months = AppDateUtils.generateRecentMonths();
      final years = AppDateUtils.generateRecentYears();

      final categories = await categoryService.getAll();
      final categoriesMap = {for (final cat in categories) cat.id!: cat};

      emit(state.copyWith(months: months, years: years, selectedMonthIndex: months.length - 1, selectedYearIndex: years.length - 1, categories: categories, categoriesMap: categoriesMap, isLoading: false));
      add(const RefreshChart());
    } catch (e) {
      logger.e('❤️ ERROR: ChartBloc error: $e');
    }
  }

  void _onChangeTransactionType(ChangeTransactionType event, Emitter<ChartState> emit) {
    if (state.selectedTransactionType == event.transactionType) return;
    emit(state.copyWith(selectedTransactionType: event.transactionType));
    add(const RefreshChart());
  }

  void _onChangePeriodType(ChangePeriodType event, Emitter<ChartState> emit) {
    emit(state.copyWith(selectedPeriodType: event.periodType));
    add(const RefreshChart());
  }

  void _onSelectMonth(SelectMonth event, Emitter<ChartState> emit) {
    emit(state.copyWith(selectedMonthIndex: event.monthIndex));
    add(const RefreshChart());
  }

  void _onSelectYear(SelectYear event, Emitter<ChartState> emit) {
    emit(state.copyWith(selectedYearIndex: event.yearIndex));
    add(const RefreshChart());
  }

  void _onLoadMoreMonths(LoadMoreMonths event, Emitter<ChartState> emit) {
    final newMonths = _generateMoreMonths(state.months);
    final currentSelectedIndex = state.selectedMonthIndex;

    emit(state.copyWith(months: newMonths, selectedMonthIndex: currentSelectedIndex + (newMonths.length - state.months.length)));
  }

  void _onLoadMoreYears(LoadMoreYears event, Emitter<ChartState> emit) {
    final newYears = _generateMoreYears(state.years);
    final currentSelectedIndex = state.selectedYearIndex;

    emit(state.copyWith(years: newYears, selectedYearIndex: currentSelectedIndex + (newYears.length - state.years.length)));
  }

  Future<void> _onRefreshChart(RefreshChart event, Emitter<ChartState> emit) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      List<Transaction> transactions = [];

      if (state.selectedPeriodType == IncomeType.month && state.selectedMonth != null) {
        final selectedMonth = state.selectedMonth!;
        final result = await transactionService.getTransactionsInMonth(year: selectedMonth.year, month: selectedMonth.month);
        transactions = result.transactions;
      } else if (state.selectedPeriodType == IncomeType.year && state.selectedYear != null) {
        transactions = await transactionService.getTransactionsInYear(state.selectedYear!);
      }

      // Filter by transaction type
      transactions = transactions.where((t) {
        final category = state.categoriesMap[t.transactionCategoryId];
        return category?.transactionType == state.selectedTransactionType;
      }).toList();

      // Group by category and calculate totals + pick gradient from category
      final Map<int, double> categoryTotals = {};
      final Map<int, List<String>> categoryGradients = {};
      for (final transaction in transactions) {
        final catId = transaction.transactionCategoryId;
        final category = state.categoriesMap[catId];
        categoryTotals[catId] = (categoryTotals[catId] ?? 0) + transaction.amount.toDouble();
        if (category != null) {
          categoryGradients.putIfAbsent(catId, () => category.gradientColors);
        }
      }

      // Build chart items with category ids
      final entries = categoryTotals.entries.toList();
      final totalAmount = categoryTotals.values.fold(0.0, (sum, amount) => sum + amount);
      final List<ChartData> chartData = [];
      final List<int> chartCategoryIds = [];
      for (final entry in entries) {
        final category = state.categoriesMap[entry.key];
        final percentage = totalAmount > 0 ? (entry.value / totalAmount) * 100 : 0;
        chartData.add(ChartData(category?.title ?? 'Khác', percentage.toDouble(), _getCategoryColor(category?.id ?? 0)));
        chartCategoryIds.add(entry.key);
      }

      // Sort both lists by percentage desc
      final indices = List<int>.generate(chartData.length, (i) => i)..sort((a, b) => chartData[b].value.compareTo(chartData[a].value));
      final sortedData = [for (final i in indices) chartData[i]];
      final sortedCatIds = [for (final i in indices) chartCategoryIds[i]];
      // if (transactions.isEmpty || sortedData.isEmpty) {
      //   return;
      // }
      emit(state.copyWith(chartData: sortedData, chartCategoryIds: sortedCatIds, categoryGradients: categoryGradients, localTransactions: transactions, localCategoryTotals: categoryTotals, localCategoryGradients: categoryGradients, isLoading: false));
    } catch (e) {
      logger.e('❤️ ERROR: ChartBloc error: $e');
    }
  }

  List<DateTime> _generateMoreMonths(List<DateTime> currentMonths) {
    return AppDateUtils.generateMoreMonths(currentMonths);
  }

  List<int> _generateMoreYears(List<int> currentYears) {
    return AppDateUtils.generateMoreYears(currentYears);
  }

  Color _getCategoryColor(int categoryId) {
    return GradientHelper.generateCategoryColor(categoryId);
  }

  /// Validates if a transaction affects the currently selected period
  bool _isTransactionInCurrentPeriod(Transaction transaction) {
    if (state.selectedPeriodType == IncomeType.month && state.selectedMonth != null) {
      final selectedMonth = state.selectedMonth!;
      return transaction.date.year == selectedMonth.year && transaction.date.month == selectedMonth.month;
    } else if (state.selectedPeriodType == IncomeType.year && state.selectedYear != null) {
      return transaction.date.year == state.selectedYear;
    }
    return false;
  }

  /// Validates if a transaction matches the current transaction type filter
  bool _isTransactionMatchingCurrentType(Transaction transaction) {
    final category = state.categoriesMap[transaction.transactionCategoryId];
    return category?.transactionType == state.selectedTransactionType;
  }

  /// Handles adding a transaction to local state
  void _onAddTransactionLocal(AddTransactionLocal event, Emitter<ChartState> emit) {
    final transaction = event.transaction;

    // Only add if transaction type matches current selection
    if (!_isTransactionMatchingCurrentType(transaction)) return;

    final newTransactions = [...state.localTransactions, transaction];

    emit(state.copyWith(localTransactions: newTransactions));
    _recalculateChartDataFromLocal(emit);
  }

  /// Handles updating a transaction in local state
  void _onUpdateTransactionLocal(UpdateTransactionLocal event, Emitter<ChartState> emit) {
    final updatedTransaction = event.transaction;

    // Only update if transaction type matches current selection
    if (!_isTransactionMatchingCurrentType(updatedTransaction)) return;

    final transactionIndex = state.localTransactions.indexWhere((t) => t.id == updatedTransaction.id);

    if (transactionIndex == -1) return;

    final newTransactions = List<Transaction>.from(state.localTransactions);
    newTransactions[transactionIndex] = updatedTransaction;

    emit(state.copyWith(localTransactions: newTransactions));
    _recalculateChartDataFromLocal(emit);
  }

  /// Handles deleting a transaction from local state
  void _onDeleteTransactionLocal(DeleteTransactionLocal event, Emitter<ChartState> emit) {
    final transactionId = event.transactionId;
    final transactionIndex = state.localTransactions.indexWhere((t) => t.id == transactionId);

    if (transactionIndex == -1) return;

    final newTransactions = List<Transaction>.from(state.localTransactions)..removeAt(transactionIndex);

    emit(state.copyWith(localTransactions: newTransactions));
    _recalculateChartDataFromLocal(emit);
  }

  /// Recalculates chart data from local transactions
  void _recalculateChartDataFromLocal(Emitter<ChartState> emit) {
    // Group by category and calculate totals + pick gradient from category
    final Map<int, double> categoryTotals = {};
    final Map<int, List<String>> categoryGradients = {};

    for (final transaction in state.localTransactions) {
      final catId = transaction.transactionCategoryId;
      final category = state.categoriesMap[catId];
      categoryTotals[catId] = (categoryTotals[catId] ?? 0) + transaction.amount.toDouble();
      if (category != null) {
        categoryGradients.putIfAbsent(catId, () => category.gradientColors);
      }
    }

    // Build chart items with category ids
    final entries = categoryTotals.entries.toList();
    final totalAmount = categoryTotals.values.fold(0.0, (sum, amount) => sum + amount);

    final List<ChartData> chartData = [];
    final List<int> chartCategoryIds = [];

    for (final entry in entries) {
      final category = state.categoriesMap[entry.key];
      final percentage = totalAmount > 0 ? (entry.value / totalAmount) * 100 : 0;
      chartData.add(ChartData(category?.title ?? 'Khác', percentage.toDouble(), _getCategoryColor(category?.id ?? 0)));
      chartCategoryIds.add(entry.key);
    }

    // Sort both lists by percentage desc
    final indices = List<int>.generate(chartData.length, (i) => i)..sort((a, b) => chartData[b].value.compareTo(chartData[a].value));
    final sortedData = [for (final i in indices) chartData[i]];
    final sortedCatIds = [for (final i in indices) chartCategoryIds[i]];

    // Check if chart is empty and prevent redraw if it's the same as current state
    final isChartEmpty = sortedData.isEmpty;
    final wasChartEmpty = state.chartData.isEmpty;

    // If chart is empty and was already empty, don't redraw to prevent UI flashing
    if (isChartEmpty && wasChartEmpty) {
      emit(state.copyWith(localCategoryTotals: categoryTotals, localCategoryGradients: categoryGradients));
      return;
    }

    emit(state.copyWith(chartData: sortedData, chartCategoryIds: sortedCatIds, categoryGradients: categoryGradients, localCategoryTotals: categoryTotals, localCategoryGradients: categoryGradients));
  }
}
