import 'package:drift/drift.dart';
import '../../database/export.dart';

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
}
