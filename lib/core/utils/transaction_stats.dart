import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/utils/date.dart';

class TransactionCalculator {
  TransactionCalculator._();

  static double calculateIncome(List<Transaction> transactions) {
    final incomeTransactions = transactions
        .where((t) => t.transactionType == TransactionType.income.typeIndex)
        .toList();
    final total = incomeTransactions.fold(0.0, (sum, t) => sum + t.amount);

    return total;
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

  static DailyTransactionTotal calculateDailyTotal(
    List<Transaction> transactions,
  ) {
    return DailyTransactionTotal(
      income: calculateIncome(transactions),
      expense: calculateExpense(transactions),
      transfer: calculateTransfer(transactions),
    );
  }

  static double calculateBalance(List<Transaction> transactions) {
    return calculateIncome(transactions) -
        calculateExpense(transactions) -
        calculateTransfer(transactions);
  }

  static int calculateTotalAmount(List<Transaction> transactions) {
    return transactions.fold<int>(0, (sum, tx) => sum + tx.amount);
  }

  static int calculateTotalAmountByType(
    List<Transaction> transactions,
    int transactionType,
  ) {
    return transactions
        .where((tx) => tx.transactionType == transactionType)
        .fold<int>(0, (sum, tx) => sum + tx.amount);
  }

  static int calculateTotalAmountByCategory(
    List<Transaction> transactions,
    int categoryId,
  ) {
    return transactions
        .where((tx) => tx.transactionCategoryId == categoryId)
        .fold<int>(0, (sum, tx) => sum + tx.amount);
  }

  static int calculateTotalAmountByCategoryAndType(
    List<Transaction> transactions,
    int categoryId,
    int transactionType,
  ) {
    return transactions
        .where(
          (tx) =>
              tx.transactionCategoryId == categoryId &&
              tx.transactionType == transactionType,
        )
        .fold<int>(0, (sum, tx) => sum + tx.amount);
  }

  static Map<String, DailyTransactionTotal> calculateMonthlyTotals(
    List<Transaction> transactions,
    int year,
    int month,
  ) {
    final monthRange = AppDateUtils.monthRangeUtc(year, month);
    final startLocal = monthRange.startUtc.toLocal();
    final endLocal = monthRange.endUtc.toLocal();

    final monthlyTransactions = transactions
        .where(
          (tx) => !tx.date.isBefore(startLocal) && tx.date.isBefore(endLocal),
        )
        .toList();

    final Map<String, List<Transaction>> grouped = {};
    for (final tx in monthlyTransactions) {
      final dateKey = AppDateUtils.formatDateKey(tx.date);
      grouped.putIfAbsent(dateKey, () => []).add(tx);
    }

    return grouped.map(
      (dateKey, txList) => MapEntry(dateKey, calculateDailyTotal(txList)),
    );
  }

  static Map<String, DailyTransactionTotal> calculateYearlyTotals(
    List<Transaction> transactions,
    int year,
  ) {
    final yearRange = AppDateUtils.yearRangeUtc(year);
    final startLocal = yearRange.startUtc.toLocal();
    final endLocal = yearRange.endUtc.toLocal();

    final yearlyTransactions = transactions
        .where(
          (tx) => !tx.date.isBefore(startLocal) && tx.date.isBefore(endLocal),
        )
        .toList();

    final Map<String, List<Transaction>> grouped = {};
    for (final tx in yearlyTransactions) {
      final monthKey =
          '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(monthKey, () => []).add(tx);
    }

    return grouped.map(
      (monthKey, txList) => MapEntry(monthKey, calculateDailyTotal(txList)),
    );
  }

  static List<Transaction> filterTransactionsByDateRange(
    List<Transaction> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    return transactions
        .where(
          (tx) =>
              !tx.date.isBefore(startDate) &&
              tx.date.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();
  }

  static List<Transaction> filterTransactionsByMonth(
    List<Transaction> transactions,
    int year,
    int month,
  ) {
    final monthRange = AppDateUtils.monthRangeUtc(year, month);
    final startLocal = monthRange.startUtc.toLocal();
    final endLocal = monthRange.endUtc.toLocal();

    return filterTransactionsByDateRange(transactions, startLocal, endLocal);
  }

  static List<Transaction> filterTransactionsByYear(
    List<Transaction> transactions,
    int year,
  ) {
    final yearRange = AppDateUtils.yearRangeUtc(year);
    final startLocal = yearRange.startUtc.toLocal();
    final endLocal = yearRange.endUtc.toLocal();

    return filterTransactionsByDateRange(transactions, startLocal, endLocal);
  }

  static Map<int, DailyTransactionTotal> calculateCategoryTotals(
    List<Transaction> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    final filteredTransactions = filterTransactionsByDateRange(
      transactions,
      startDate,
      endDate,
    );

    final Map<int, List<Transaction>> grouped = {};
    for (final tx in filteredTransactions) {
      grouped.putIfAbsent(tx.transactionCategoryId, () => []).add(tx);
    }

    return grouped.map(
      (categoryId, txList) => MapEntry(categoryId, calculateDailyTotal(txList)),
    );
  }

  static double calculateCategorySpendingPercentage(
    List<Transaction> transactions,
    int categoryId,
    int year,
    int month,
  ) {
    final monthlyTransactions = filterTransactionsByMonth(
      transactions,
      year,
      month,
    );
    final totalExpense = calculateExpense(monthlyTransactions);

    if (totalExpense == 0) return 0.0;

    final categoryExpense = calculateExpense(
      monthlyTransactions
          .where(
            (tx) =>
                tx.transactionCategoryId == categoryId &&
                tx.transactionType == TransactionType.expense.typeIndex,
          )
          .toList(),
    );

    return (categoryExpense / totalExpense) * 100;
  }
}
