import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_state.freezed.dart';

@freezed
abstract class ReportState with _$ReportState {
  const factory ReportState({
    @Default(false) bool isLoading,
    DateTime? period,
    @Default({}) Map<int, int> budgetsByCategory, // categoryId -> budget amount
    @Default({}) Map<int, int> spentByCategory, // categoryId -> spent in month
    String? message,
  }) = _ReportState;
}
