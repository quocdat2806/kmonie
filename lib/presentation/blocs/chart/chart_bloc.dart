import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'package:kmonie/presentation/widgets/chart_circular/chart_circular.dart';
import 'package:kmonie/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'chart_event.dart';
import 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final TransactionRepository transactionRepository;
  final TransactionCategoryRepository categoryRepository;

  ChartBloc(this.transactionRepository, this.categoryRepository) : super(const ChartState()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<ChangeTransactionType>(_onChangeTransactionType);
    on<ChangePeriodType>(_onChangePeriodType);
    on<SelectMonth>(_onSelectMonth);
    on<SelectYear>(_onSelectYear);
    on<LoadMoreMonths>(_onLoadMoreMonths);
    on<LoadMoreYears>(_onLoadMoreYears);
    on<RefreshChart>(_onRefreshChart);

    add(const LoadInitialData());
  }

  Future<void> _onLoadInitialData(LoadInitialData event, Emitter<ChartState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final months = AppDateUtils.generateRecentMonths();
      final years = AppDateUtils.generateRecentYears();

      emit(state.copyWith(months: months, years: years, selectedMonthIndex: months.length - 1, selectedYearIndex: years.length - 1, isLoading: false));

      add(const RefreshChart());
    } catch (e) {
      logger.e('❤️ ERROR: ChartBloc error: $e');
      emit(state.copyWith(isLoading: false));
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
      // Lấy transactions theo period và type
      final transactionsResult = await _getTransactionsForCurrentPeriod();

      await transactionsResult.fold(
        (failure) async {
          logger.e('Failed to load transactions: ${failure.message}');
          emit(state.copyWith(chartData: [], isLoading: false));
        },
        (transactions) async {
          // Lấy categories để map tên
          final categoriesResult = await categoryRepository.getAll();

          await categoriesResult.fold(
            (failure) async {
              logger.e('Failed to load categories: ${failure.message}');
              emit(state.copyWith(chartData: [], isLoading: false));
            },
            (categories) async {
              final chartData = _calculateChartData(transactions, categories);
              emit(state.copyWith(chartData: chartData, isLoading: false));
            },
          );
        },
      );
    } catch (e) {
      logger.e('❤️ ERROR: ChartBloc error: $e');
      emit(state.copyWith(chartData: [], isLoading: false));
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

  /// Lấy transactions theo period hiện tại
  Future<Either<Failure, List<Transaction>>> _getTransactionsForCurrentPeriod() async {
    if (state.selectedPeriodType == IncomeType.month && state.selectedMonth != null) {
      final selectedMonth = state.selectedMonth!;
      logger.d('ChartBloc: Loading transactions for month ${selectedMonth.year}/${selectedMonth.month}');

      // Lấy tất cả transactions với page size lớn để không bị phân trang
      final result = await transactionRepository.getTransactionsInMonth(
        year: selectedMonth.year,
        month: selectedMonth.month,
        pageSize: 10000, // Page size lớn để lấy tất cả
        pageIndex: 0,
      );

      return result.map((data) {
        return data.transactions;
      });
    } else if (state.selectedPeriodType == IncomeType.year && state.selectedYear != null) {
      return await transactionRepository.getTransactionsInYear(state.selectedYear!);
    }

    return const Right([]);
  }

  List<ChartData> _calculateChartData(List<Transaction> transactions, List<TransactionCategory> categories) {
    final categoriesMap = {for (final cat in categories) cat.id!: cat};

    final filteredTransactions = transactions.where((transaction) {
      final category = categoriesMap[transaction.transactionCategoryId];
      final matches = category?.transactionType == state.selectedTransactionType;

      if (transaction.transactionType == TransactionType.income.typeIndex) {
        logger.d('ChartBloc: Income transaction - Category: ${category?.title}, Matches: $matches, TransactionType: ${transaction.transactionType}, CategoryType: ${category?.transactionType}');
      }

      return matches;
    }).toList();

    logger.d('ChartBloc: Filtered transactions: ${filteredTransactions.length}');

    final Map<int, double> categoryTotals = {};
    for (final transaction in filteredTransactions) {
      final catId = transaction.transactionCategoryId;
      categoryTotals[catId] = (categoryTotals[catId] ?? 0) + transaction.amount.toDouble();
    }

    logger.d('ChartBloc: Category totals: $categoryTotals');

    // Tạo chart data
    final totalAmount = categoryTotals.values.fold(0.0, (sum, amount) => sum + amount);
    final List<ChartData> chartData = [];

    for (final entry in categoryTotals.entries) {
      final category = categoriesMap[entry.key];
      final percentage = totalAmount > 0 ? (entry.value / totalAmount) * 100 : 0;
      chartData.add(ChartData(category?.title ?? 'Khác', percentage.toDouble(), _getCategoryColor(category?.id ?? 0), gradientColors: category?.gradientColors, category: category));

      logger.d('ChartBloc: Chart data - Category: ${category?.title}, Amount: ${entry.value}, Percentage: ${percentage.toStringAsFixed(2)}%');
    }

    // Sort theo percentage desc
    chartData.sort((a, b) => b.value.compareTo(a.value));

    logger.d('ChartBloc: Final chart data count: ${chartData.length}');
    return chartData;
  }
}
