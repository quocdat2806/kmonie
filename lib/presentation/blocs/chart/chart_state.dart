import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/args/args.dart';

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
    @Default([]) List<ChartDataArgs> chartData,
    @Default(LoadStatus.initial) LoadStatus loadStatus,
  }) = _ChartState;

  const ChartState._();

  DateTime? get selectedMonth =>
      months.isNotEmpty ? months[selectedMonthIndex] : null;

  int? get selectedYear => years.isNotEmpty ? years[selectedYearIndex] : null;
}
