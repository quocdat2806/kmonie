import '../../database/export.dart';
import '../../entity/export.dart';
import '../enum/export.dart';
import '../util/export.dart';

class TransactionCategoryService {
  final KMonieDatabase _db;
  TransactionCategoryService(this._db);
  List<TransactionCategory>? _cachedCategories;
  bool _isCacheInitialized = false;

  void clearCache() {
    _cachedCategories = null;
    _isCacheInitialized = false;
  }

  Stream<List<TransactionCategory>> watchAll() {
    return _db.select(_db.transactionCategoryTb).watch().map((rows) {
      final list = rows.map(_mapRow).toList();
      _cachedCategories = list;
      _isCacheInitialized = true;
      return list;
    });
  }

  TransactionCategory _mapRow(TransactionCategoryTbData r) {
    return TransactionCategory(id: r.id, title: r.title, pathAsset: r.pathAsset, transactionType: TransactionType.values[r.transactionType], isCreateNewCategory: r.isCreateNewCategory);
  }

  Future<List<TransactionCategory>> getAll({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheInitialized && _cachedCategories != null) {
      return _cachedCategories!;
    }

    final rows = await _db.select(_db.transactionCategoryTb).get();
    _cachedCategories = rows.map(_mapRow).toList();
    _isCacheInitialized = true;
    return _cachedCategories!;
  }

  Future<List<TransactionCategory>> getByType(TransactionType type) async {
    try {
      if (_isCacheInitialized && _cachedCategories != null) {
        return _cachedCategories!.where((e) => e.transactionType == type).toList();
      }

      final q = _db.select(_db.transactionCategoryTb)..where((t) => t.transactionType.equals(type.typeIndex));
      final rows = await q.get();
      return rows.map(_mapRow).toList();
    } catch (e) {
      logger.e('TransactionCategoryService.getByType error: $e');
      return [];
    }
  }

  Future<SeparatedCategories> getSeparated({bool forceRefresh = false}) async {
    final all = await getAll(forceRefresh: forceRefresh);
    final expense = <TransactionCategory>[];
    final income = <TransactionCategory>[];
    final transfer = <TransactionCategory>[];

    for (final e in all) {
      switch (e.transactionType) {
        case TransactionType.expense:
          expense.add(e);
          break;
        case TransactionType.income:
          income.add(e);
          break;
        case TransactionType.transfer:
          transfer.add(e);
          break;
      }
    }

    return SeparatedCategories(expense: expense, income: income, transfer: transfer);
  }

  Stream<List<TransactionCategory>> watchByType(TransactionType type) {
    final q = _db.select(_db.transactionCategoryTb)..where((t) => t.transactionType.equals(type.typeIndex));
    return q.watch().map((rows) {
      final list = rows.map(_mapRow).toList();
      if (_cachedCategories != null) {
        _cachedCategories!.removeWhere((e) => e.transactionType == type);
        _cachedCategories!.addAll(list);
      }
      return list;
    });
  }

  Stream<SeparatedCategories> watchSeparated() {
    return _db.select(_db.transactionCategoryTb).watch().map((rows) {
      final list = rows.map(_mapRow).toList();
      _cachedCategories = list;
      _isCacheInitialized = true;

      final expense = <TransactionCategory>[];
      final income = <TransactionCategory>[];
      final transfer = <TransactionCategory>[];

      for (final e in list) {
        switch (e.transactionType) {
          case TransactionType.expense:
            expense.add(e);
            break;
          case TransactionType.income:
            income.add(e);
            break;
          case TransactionType.transfer:
            transfer.add(e);
            break;
        }
      }

      return SeparatedCategories(expense: expense, income: income, transfer: transfer);
    });
  }
}

class SeparatedCategories {
  final List<TransactionCategory> expense;
  final List<TransactionCategory> income;
  final List<TransactionCategory> transfer;

  const SeparatedCategories({required this.expense, required this.income, required this.transfer});
}
