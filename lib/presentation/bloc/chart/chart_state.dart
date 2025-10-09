import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/enum/export.dart';
import '../../../entity/export.dart';
import '../../widgets/chart/app_chart.dart';

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
    // Category ids aligned with chartData indices for UI mapping
    @Default([]) List<int> chartCategoryIds,
    // Gradient colors per category id (hex strings)
    @Default({}) Map<int, List<String>> categoryGradients,
    @Default([]) List<TransactionCategory> categories,
    @Default({}) Map<int, TransactionCategory> categoriesMap,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _ChartState;

  const ChartState._();

  DateTime? get selectedMonth => months.isNotEmpty ? months[selectedMonthIndex] : null;
  int? get selectedYear => years.isNotEmpty ? years[selectedYearIndex] : null;
}
