import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/utils/utils.dart';
part 'calendar_monthly_transaction_state.freezed.dart';

@freezed
abstract class CalendarMonthTransactionState with _$CalendarMonthTransactionState {
  const factory CalendarMonthTransactionState({@Default(false) bool isLoading, DateTime? selectedDate, @Default({}) Map<String, List<Transaction>> groupedTransactions, @Default({}) Map<int, TransactionCategory> categoriesMap}) = _CalendarMonthTransactionState;
  const CalendarMonthTransactionState._();

  Map<int, DailyTransactionTotal> get dailyTotals {
    final result = <int, DailyTransactionTotal>{};
    for (final entry in groupedTransactions.entries) {
      final date = AppDateUtils.parseDateKey(entry.key);
      result[date.day] = TransactionCalculator.calculateDailyTotal(entry.value);
    }
    return result;
  }
}
