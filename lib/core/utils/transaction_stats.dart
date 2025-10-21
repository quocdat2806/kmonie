import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/enums/enums.dart';

class TransactionCalculator {
  static double calculateIncome(List<Transaction> transactions) {
    return transactions
        .where((t) => t.transactionType == TransactionType.income.typeIndex)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double calculateExpense(List<Transaction> transactions) {
    return transactions
        .where((t) => t.transactionType == TransactionType.expense.typeIndex)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double calculateTransfer(List<Transaction> transactions) {
    return transactions
        .where((t) => t.transactionType == TransactionType.transfer.typeIndex)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double calculateBalance(List<Transaction> transactions) {
    return calculateIncome(transactions) -
        calculateExpense(transactions) -
        calculateTransfer(transactions);
  }
}
