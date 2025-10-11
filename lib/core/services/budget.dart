import 'package:drift/drift.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/core/enums/enums.dart';

class BudgetService {
  final KMonieDatabase _db;

  BudgetService(this._db);

  Future<Map<int, int>> getBudgetsForMonth(int year, int month) async {
    final q = _db.select(_db.budgetsTb)..where((t) => t.year.equals(year) & t.month.equals(month));
    final rows = await q.get();
    final Map<int, int> result = {};
    for (final r in rows) {
      result[r.transactionCategoryId] = r.amount;
    }
    return result;
  }

  Future<int> getBudgetForCategory({required int year, required int month, required int categoryId}) async {
    final q = _db.select(_db.budgetsTb)..where((t) => t.year.equals(year) & t.month.equals(month) & t.transactionCategoryId.equals(categoryId));

    final row = await q.getSingleOrNull();
    return row?.amount ?? 0;
  }

  Future<void> setBudgetForCategory({required int year, required int month, required int categoryId, required int amount}) async {
    if (amount <= 0) {
      await (_db.delete(_db.budgetsTb)..where((t) => t.year.equals(year) & t.month.equals(month) & t.transactionCategoryId.equals(categoryId))).go();
      return;
    }

    final companion = BudgetsTbCompanion(year: Value(year), month: Value(month), transactionCategoryId: Value(categoryId), amount: Value(amount));

    await _db.into(_db.budgetsTb).insertOnConflictUpdate(companion);
  }

  Future<int> getMonthlyBudget({required int year, required int month}) async {
    final q = _db.select(_db.monthlyBudgetsTb)..where((t) => t.year.equals(year) & t.month.equals(month));

    final row = await q.getSingleOrNull();
    return row?.totalAmount ?? 0;
  }

  Future<void> setMonthlyBudget({required int year, required int month, required int amount}) async {
    if (amount <= 0) {
      await (_db.delete(_db.monthlyBudgetsTb)..where((t) => t.year.equals(year) & t.month.equals(month))).go();
      return;
    }

    final companion = MonthlyBudgetsTbCompanion(year: Value(year), month: Value(month), totalAmount: Value(amount));

    await _db.into(_db.monthlyBudgetsTb).insertOnConflictUpdate(companion);
  }

  // Get total spent amount for a month
  Future<int> getTotalSpentForMonth({required int year, required int month}) async {
    final startDate = DateTime(year, month);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

    final q = _db.select(_db.transactionsTb)..where((t) => t.date.isBiggerOrEqualValue(startDate) & t.date.isSmallerOrEqualValue(endDate) & t.transactionType.equals(TransactionType.expense.typeIndex));

    final transactions = await q.get();
    return transactions.fold<int>(0, (sum, transaction) => sum + transaction.amount);
  }

  // Get spent amount for a specific category in a month
  Future<int> getSpentForCategory({required int year, required int month, required int categoryId}) async {
    final startDate = DateTime(year, month);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

    final q = _db.select(_db.transactionsTb)..where((t) => t.date.isBiggerOrEqualValue(startDate) & t.date.isSmallerOrEqualValue(endDate) & t.transactionCategoryId.equals(categoryId) & t.transactionType.equals(TransactionType.expense.typeIndex));

    final transactions = await q.get();
    return transactions.fold<int>(0, (sum, transaction) => sum + transaction.amount);
  }
}
