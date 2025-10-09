import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/export.dart';
import '../../../core/service/export.dart';
import '../../../core/stream/export.dart';
import '../../../entity/export.dart';
import '../../widgets/chart/app_chart.dart';
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

    // Listen to transaction changes
    _subscription = AppStreamEvent.eventStreamStatic.listen((data) {
      switch (data.event) {
        case AppEvent.insertTransaction:
        case AppEvent.updateTransaction:
        case AppEvent.deleteTransaction:
          add(const RefreshChart());
          break;
      }
    });

    // Load initial data
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
      // Generate months and years
      final months = _generateMonths();
      final years = _generateYears();

      // Load categories
      final categories = await categoryService.getAll();
      final categoriesMap = {for (final cat in categories) cat.id!: cat};

      emit(
        state.copyWith(
          months: months,
          years: years,
          selectedMonthIndex: months.length - 1, // Current month
          selectedYearIndex: years.length - 1, // Current year
          categories: categories,
          categoriesMap: categoriesMap,
          isLoading: false,
        ),
      );

      // Load chart data
      add(const RefreshChart());
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Lỗi tải dữ liệu: $e'));
    }
  }

  void _onChangeTransactionType(ChangeTransactionType event, Emitter<ChartState> emit) {
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

      // Group by category and calculate totals + pick gradient from a sample transaction
      final Map<int, double> categoryTotals = {};
      final Map<int, List<String>> categoryGradients = {};
      for (final transaction in transactions) {
        final catId = transaction.transactionCategoryId;
        categoryTotals[catId] = (categoryTotals[catId] ?? 0) + transaction.amount.toDouble();
        categoryGradients.putIfAbsent(catId, () => transaction.gradientColors);
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
      final indices = List<int>.generate(chartData.length, (i) => i);
      indices.sort((a, b) => chartData[b].value.compareTo(chartData[a].value));
      final sortedData = [for (final i in indices) chartData[i]];
      final sortedCatIds = [for (final i in indices) chartCategoryIds[i]];

      emit(state.copyWith(chartData: sortedData, chartCategoryIds: sortedCatIds, categoryGradients: categoryGradients, isLoading: false, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(chartData: [], isLoading: false, errorMessage: 'Lỗi tải dữ liệu biểu đồ: $e'));
    }
  }

  List<DateTime> _generateMonths() {
    final DateTime now = DateTime.now();
    const int initialMonthCount = 12;
    final List<DateTime> months = [];

    for (int i = initialMonthCount - 1; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i);
      months.add(month);
    }
    return months;
  }

  List<int> _generateYears() {
    final DateTime now = DateTime.now();
    final List<int> years = [];

    // Generate years from 5 years ago to current year
    for (int i = 5; i >= 0; i--) {
      years.add(now.year - i);
    }
    return years;
  }

  List<DateTime> _generateMoreMonths(List<DateTime> currentMonths) {
    final List<DateTime> newMonths = [];
    final DateTime oldestMonth = currentMonths.first;

    for (int i = 12; i >= 1; i--) {
      final month = DateTime(oldestMonth.year, oldestMonth.month - i);
      newMonths.add(month);
    }

    return [...newMonths, ...currentMonths];
  }

  List<int> _generateMoreYears(List<int> currentYears) {
    final List<int> newYears = [];
    final int oldestYear = currentYears.first;

    for (int i = 5; i >= 1; i--) {
      newYears.add(oldestYear - i);
    }

    return [...newYears, ...currentYears];
  }

  Color _getCategoryColor(int categoryId) {
    // Generate consistent colors based on category ID
    final colors = [
      const Color(0xFF4CAF50), // Green
      const Color(0xFFFFC107), // Yellow
      const Color(0xFFFF5722), // Red
      const Color(0xFF2196F3), // Blue
      const Color(0xFF9C27B0), // Purple
      const Color(0xFFFF9800), // Orange
      const Color(0xFF795548), // Brown
      const Color(0xFF607D8B), // Blue Grey
    ];
    return colors[categoryId % colors.length];
  }
}
