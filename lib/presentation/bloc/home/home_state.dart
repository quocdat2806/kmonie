import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/enum/export.dart';
import '../../../entity/export.dart';

part 'home_state.freezed.dart';

class DailyTransactionTotal {
  final double income;
  final double expense;
  final double transfer;

  const DailyTransactionTotal({
    this.income = 0,
    this.expense = 0,
    this.transfer = 0,
  });

  DailyTransactionTotal copyWith({
    double? income,
    double? expense,
    double? transfer,
  }) {
    return DailyTransactionTotal(
      income: income ?? this.income,
      expense: expense ?? this.expense,
      transfer: transfer ?? this.transfer,
    );
  }
}

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

  double get totalIncome {
    return transactions
        .where(
          (transaction) =>
              transaction.transactionType == TransactionType.income.typeIndex,
        )
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }



  double get totalExpense {
    return transactions
        .where(
          (transaction) =>
              transaction.transactionType == TransactionType.expense.typeIndex,
        )
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }
  double get totalTransfer {
    return transactions
        .where((t) => t.transactionType == TransactionType.transfer.typeIndex)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalBalance {
    return totalIncome - totalExpense -totalTransfer;
  }



  double get totalAmount {
    return transactions.fold(
      0.0,
      (sum, transaction) => sum + transaction.amount,
    );
  }
}
