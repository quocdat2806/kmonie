import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../entity/export.dart';

part 'calendar_monthly_transaction_state.freezed.dart';

@freezed
abstract class CalendarMonthTransactionState
    with _$CalendarMonthTransactionState {
  const factory CalendarMonthTransactionState({
    @Default(false) bool isLoading,
    DateTime? selectedDate,
    @Default({}) Map<int, DailyTransactionTotal> dailyTotals,
    @Default({}) Map<String, List<Transaction>> groupedTransactions,
    @Default({}) Map<int, TransactionCategory> categoriesMap,
  }) = _CalendarMonthTransactionState;
}
