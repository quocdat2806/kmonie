import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kmonie/core/enums/enums.dart';

part 'chart_event.freezed.dart';

@freezed
class ChartEvent with _$ChartEvent {
  const factory ChartEvent.loadInitialData() = LoadInitialData;
  const factory ChartEvent.changeTransactionType(TransactionType transactionType) = ChangeTransactionType;
  const factory ChartEvent.changePeriodType(IncomeType periodType) = ChangePeriodType;
  const factory ChartEvent.selectMonth(int monthIndex) = SelectMonth;
  const factory ChartEvent.selectYear(int yearIndex) = SelectYear;
  const factory ChartEvent.loadMoreMonths() = LoadMoreMonths;
  const factory ChartEvent.loadMoreYears() = LoadMoreYears;
  const factory ChartEvent.refreshChart() = RefreshChart;
}
