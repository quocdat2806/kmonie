import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../entity/exports.dart';
import '../../../core/enum/exports.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<Transaction> transactions,
    @Default({}) Map<String, List<Transaction>> groupedTransactions,
    @Default({}) Map<int, TransactionCategory> categoriesMap,
    @Default(0) int pageIndex,
    @Default(false) bool isLoadingMore,
    int ? totalRecords,
    TransactionType? selectedType,

    DateTime? selectedDate,
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

  double get totalBalance {
    return totalIncome - totalExpense;
  }

  double get totalAmount {
    return transactions.fold(
      0.0,
      (sum, transaction) => sum + transaction.amount,
    );
  }
}
