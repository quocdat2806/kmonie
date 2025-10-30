import 'package:drift/drift.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/database/database.dart';

import './transaction.dart';

class BudgetService {
  final KMonieDatabase _db;
  final TransactionService _transactionService;

  BudgetService(this._db, this._transactionService);

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
    if (amount < 0) return;
    final existing = await (_db.select(_db.budgetsTb)..where((t) => t.year.equals(year) & t.month.equals(month) & t.transactionCategoryId.equals(categoryId))).getSingleOrNull();
    final companion = BudgetsTbCompanion(year: Value(year), month: Value(month), transactionCategoryId: Value(categoryId), amount: Value(amount));
    if (existing != null) {
      await (_db.update(_db.budgetsTb)..where((t) => t.id.equals(existing.id))).write(companion);
      return;
    }
    await _db.into(_db.budgetsTb).insert(companion);
  }

  Future<int> getMonthlyBudget({required int year, required int month}) async {
    final q = _db.select(_db.monthlyBudgetsTb)..where((t) => t.year.equals(year) & t.month.equals(month));

    final row = await q.getSingleOrNull();
    return row?.totalAmount ?? 0;
  }

  Future<void> setMonthlyBudget({required int year, required int month, required int amount}) async {
    if (amount <= 0) {
      return;
    }

    final existing = await (_db.select(_db.monthlyBudgetsTb)..where((t) => t.year.equals(year) & t.month.equals(month))).getSingleOrNull();

    final companion = MonthlyBudgetsTbCompanion(year: Value(year), month: Value(month), totalAmount: Value(amount));

    if (existing != null) {
      await (_db.update(_db.monthlyBudgetsTb)..where((t) => t.id.equals(existing.id))).write(companion);
      return;
    }
    await _db.into(_db.monthlyBudgetsTb).insert(companion);
  }

  Future<int> getTotalSpentForMonth({required int year, required int month}) async {
    return await _transactionService.calculateTotalAmountInMonth(year: year, month: month, transactionType: TransactionType.expense.typeIndex);
  }

  Future<int> getSpentForCategory({required int year, required int month, required int categoryId}) async {
    return await _transactionService.calculateTotalAmountInMonth(year: year, month: month, transactionType: TransactionType.expense.typeIndex, categoryId: categoryId);
  }

  Future<int> getTotalIncomeForMonth({required int year, required int month}) async {
    return await _transactionService.calculateTotalAmountInMonth(year: year, month: month, transactionType: TransactionType.income.typeIndex);
  }

  Future<int> getIncomeForCategory({required int year, required int month, required int categoryId}) async {
    return await _transactionService.calculateTotalAmountInMonth(year: year, month: month, transactionType: TransactionType.income.typeIndex, categoryId: categoryId);
  }

  Future<Map<int, ({int budget, int spent, double percentUsed})>> getBudgetComparison({required int year, required int month}) async {
    final budgets = await getBudgetsForMonth(year, month);
    final Map<int, ({int budget, int spent, double percentUsed})> result = {};

    for (final entry in budgets.entries) {
      final categoryId = entry.key;
      final budgetAmount = entry.value;

      final spentAmount = await _transactionService.calculateTotalAmountInMonth(year: year, month: month, transactionType: TransactionType.expense.typeIndex, categoryId: categoryId);

      final percentUsed = budgetAmount > 0 ? (spentAmount / budgetAmount) * 100 : 0.0;

      result[categoryId] = (budget: budgetAmount, spent: spentAmount, percentUsed: percentUsed);
    }

    return result;
  }

  Future<({int income, int expense, int balance})> getMonthlySummary({required int year, required int month}) async {
    final income = await getTotalIncomeForMonth(year: year, month: month);
    final expense = await getTotalSpentForMonth(year: year, month: month);
    final balance = income - expense;

    return (income: income, expense: expense, balance: balance);
  }

  Future<({List<TransactionsTbData> transactions, int totalSpent})> getCategoryBreakdown({required int year, required int month, required int categoryId}) async {
    final transactions = await _transactionService.getTransactionsFiltered(year: year, month: month, transactionType: TransactionType.expense.typeIndex, categoryId: categoryId);

    final totalSpent = transactions.fold<int>(0, (sum, tx) => sum + tx.amount);

    return (transactions: transactions, totalSpent: totalSpent);
  }
}
