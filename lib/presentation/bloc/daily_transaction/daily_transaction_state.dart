import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/utils/utils.dart';

part 'daily_transaction_state.freezed.dart';

@freezed
abstract class DailyTransactionState with _$DailyTransactionState {
  const factory DailyTransactionState({@Default(false) bool isLoading, DateTime? selectedDate, @Default({}) Map<String, List<Transaction>> groupedTransactions, @Default({}) Map<int, TransactionCategory> categoriesMap}) = _DailyTransactionState;

  const DailyTransactionState._();

  bool get isEmpty => groupedTransactions.isEmpty || groupedTransactions.values.every((list) => list.isEmpty);

  Map<String, DailyTransactionTotal> get dailyTotals {
    return groupedTransactions.map((dateKey, txList) => MapEntry(dateKey, TransactionCalculator.calculateDailyTotal(txList)));
  }
}
