import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_statistics_state.freezed.dart';

@freezed
abstract class MonthlyStatisticsState with _$MonthlyStatisticsState {
  const factory MonthlyStatisticsState({@Default(false) bool isLoading, @Default(<MonthlyAgg>[]) List<MonthlyAgg> months, int? selectedYear}) = _MonthlyStatisticsState;
}

class MonthlyAgg {
  final int year;
  final int month;
  final double income;
  final double expense;
  const MonthlyAgg({required this.year, required this.month, this.income = 0, this.expense = 0});
}
