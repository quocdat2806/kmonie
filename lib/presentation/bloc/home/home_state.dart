import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/entity/entity.dart';

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
    @Default({}) Map<String, DailyTransactionTotal> dailyTotals,
  }) = _HomeState;

  const HomeState._();

  double get totalIncome => transactions
      .where((t) => t.transactionType == TransactionType.income.typeIndex)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.transactionType == TransactionType.expense.typeIndex)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalTransfer => transactions
      .where((t) => t.transactionType == TransactionType.transfer.typeIndex)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalBalance => totalIncome - totalExpense - totalTransfer;

  double get totalAmount => transactions.fold(0.0, (sum, t) => sum + t.amount);
}
