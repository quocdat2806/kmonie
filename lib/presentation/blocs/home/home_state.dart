import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<Transaction> transactions,
    @Default({}) Map<String, List<Transaction>> groupedTransactions,
    @Default({}) Map<int, TransactionCategory> categoriesMap,
    @Default(0) int pageIndex,
    @Default(false) bool isLoadingMore,
    int? totalRecords,
    DateTime? selectedDate,
  }) = _HomeState;

  const HomeState._();

  double get totalIncome => TransactionCalculator.calculateIncome(transactions);

  double get totalExpense =>
      TransactionCalculator.calculateExpense(transactions);

  double get totalTransfer =>
      TransactionCalculator.calculateTransfer(transactions);

  double get totalBalance =>
      TransactionCalculator.calculateBalance(transactions);

  Map<String, DailyTransactionTotal> get dailyTotals {
    return groupedTransactions.map(
      (dateKey, txList) =>
          MapEntry(dateKey, TransactionCalculator.calculateDailyTotal(txList)),
    );
  }
}
