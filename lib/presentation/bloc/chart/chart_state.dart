import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/widgets/chart/app_chart.dart';

part 'chart_state.freezed.dart';

@freezed
abstract class ChartState with _$ChartState {
  const factory ChartState({
    @Default(TransactionType.expense) TransactionType selectedTransactionType,
    @Default(IncomeType.month) IncomeType selectedPeriodType,
    @Default([]) List<DateTime> months,
    @Default([]) List<int> years,
    @Default(0) int selectedMonthIndex,
    @Default(0) int selectedYearIndex,
    @Default([]) List<ChartData> chartData,
    @Default([]) List<int> chartCategoryIds,
    @Default({}) Map<int, List<String>> categoryGradients,
    @Default([]) List<TransactionCategory> categories,
    @Default({}) Map<int, TransactionCategory> categoriesMap,
    @Default(false) bool isLoading,
    @Default([]) List<Transaction> localTransactions,
    @Default({}) Map<int, double> localCategoryTotals,
    @Default({}) Map<int, List<String>> localCategoryGradients,
  }) = _ChartState;

  const ChartState._();

  DateTime? get selectedMonth => months.isNotEmpty ? months[selectedMonthIndex] : null;
  int? get selectedYear => years.isNotEmpty ? years[selectedYearIndex] : null;
}
