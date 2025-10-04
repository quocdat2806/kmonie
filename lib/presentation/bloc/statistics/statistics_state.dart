import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../entity/export.dart';
import '../../../core/enum/export.dart';

part 'statistics_state.freezed.dart';

@freezed
abstract class StatisticsState with _$StatisticsState {
  const factory StatisticsState({
    @Default(false) bool isLoading,
    @Default({}) Map<String, List<Transaction>> groupedTransactions,
    @Default({}) Map<int, TransactionCategory> categoriesMap,
    @Default(0.0) double totalAmount,
    @Default(0) int transactionCount,
    TransactionType? transactionType,
    String? message,
  }) = _StatisticsState;
}
