import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/enum/export.dart';
import '../../../entity/export.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({@Default([]) List<Transaction> transactions, @Default({}) Map<String, List<Transaction>> groupedTransactions, @Default({}) Map<int, TransactionCategory> categoriesMap, @Default(0) int pageIndex, @Default(false) bool isLoadingMore, int? totalRecords, TransactionType? selectedType, DateTime? selectedDate, @Default({}) Map<String, double> dailyIncomeTotals, @Default({}) Map<String, double> dailyExpenseTotals, @Default({}) Map<String, double> dailyTransferTotals}) =
      _HomeState;

  const HomeState._();

  double get totalIncome {
    return transactions.where((transaction) => transaction.transactionType == TransactionType.income.typeIndex).fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get calculateTotalIncome {
    return transactions
        .where((t) {
          final category = categoriesMap[t.transactionCategoryId];
          return category?.transactionType == TransactionType.income;
        })
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get calculateTotalExpense {
    return transactions
        .where((t) {
          final category = categoriesMap[t.transactionCategoryId];
          return category?.transactionType == TransactionType.expense;
        })
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return transactions.where((transaction) => transaction.transactionType == TransactionType.expense.typeIndex).fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalBalance {
    return totalIncome - totalExpense;
  }

  double get totalAmount {
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }
}
