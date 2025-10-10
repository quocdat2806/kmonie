import 'package:drift/drift.dart';
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

  TransactionCategory _mapRow(TransactionCategoryTbData r) {
    return TransactionCategory(id: r.id, title: r.title, pathAsset: r.pathAsset, transactionType: TransactionType.values[r.transactionType], isCreateNewCategory: r.isCreateNewCategory);
  }

  // ✅ Helper: Separate categories by type
  SeparatedCategories _separateCategories(List<TransactionCategory> all) {
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

  // ========== READ OPERATIONS ==========

  Stream<List<TransactionCategory>> watchAll() {
    return _db.select(_db.transactionCategoryTb).watch().map((rows) {
      final list = rows.map(_mapRow).toList();
      _cachedCategories = list;
      _isCacheInitialized = true;
      return list;
    });
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

  // ✅ NEW: Get single category by ID
  Future<TransactionCategory?> getCategoryById(int id) async {
    // Try cache first
    if (_isCacheInitialized && _cachedCategories != null) {
      try {
        return _cachedCategories!.firstWhere((e) => e.id == id);
      } catch (_) {
        // Not found in cache, fallback to DB
      }
    }

    // Query DB
    final row = await (_db.select(_db.transactionCategoryTb)..where((t) => t.id.equals(id))).getSingleOrNull();

    return row != null ? _mapRow(row) : null;
  }

  Future<List<TransactionCategory>> getByType(TransactionType type) async {
    try {
      // Use cache if available
      if (_isCacheInitialized && _cachedCategories != null) {
        return _cachedCategories!.where((e) => e.transactionType == type).toList();
      }

      // Fallback to DB query
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
    return _separateCategories(all);
  }

  // ✅ FIX: Simplified watchByType - don't manage cache here
  Stream<List<TransactionCategory>> watchByType(TransactionType type) {
    final q = _db.select(_db.transactionCategoryTb)..where((t) => t.transactionType.equals(type.typeIndex));

    // Just return the stream, let watchAll() handle cache updates
    return q.watch().map((rows) => rows.map(_mapRow).toList());
  }

  Stream<SeparatedCategories> watchSeparated() {
    return _db.select(_db.transactionCategoryTb).watch().map((rows) {
      final list = rows.map(_mapRow).toList();
      _cachedCategories = list;
      _isCacheInitialized = true;
      return _separateCategories(list);
    });
  }

  // ========== CREATE OPERATION ==========

  // ✅ NEW: Create category
  Future<TransactionCategory> createCategory({required String title, required String pathAsset, required TransactionType transactionType, bool isCreateNewCategory = true}) async {
    try {
      final id = await _db
          .into(_db.transactionCategoryTb)
          .insert(
            TransactionCategoryTbCompanion.insert(
              title: title,
              pathAsset: Value(pathAsset),
              transactionType: Value(transactionType.typeIndex),
              isCategoryDefaultSystem: const Value(false), // User-created
              isCreateNewCategory: Value(isCreateNewCategory),
            ),
          );

      clearCache(); // Invalidate cache

      return TransactionCategory(id: id, title: title, pathAsset: pathAsset, transactionType: transactionType, isCreateNewCategory: isCreateNewCategory);
    } catch (e) {
      logger.e('Error creating category: $e');
      rethrow;
    }
  }

  // ========== UPDATE OPERATION ==========

  // ✅ NEW: Update category
  Future<TransactionCategory?> updateCategory({required int id, String? title, String? pathAsset}) async {
    try {
      final companion = TransactionCategoryTbCompanion(title: title != null ? Value(title) : const Value.absent(), pathAsset: pathAsset != null ? Value(pathAsset) : const Value.absent());

      final updated = await (_db.update(_db.transactionCategoryTb)..where((t) => t.id.equals(id))).write(companion);

      if (updated > 0) {
        clearCache();
        return await getCategoryById(id);
      }
      return null;
    } catch (e) {
      logger.e('Error updating category: $e');
      return null;
    }
  }

  // ========== DELETE OPERATION ==========

  // ✅ NEW: Delete category (with safety check)
  Future<bool> deleteCategory(int id) async {
    try {
      // ⚠️ Check if category has transactions (RESTRICT constraint)
      final txCount =
          await (_db.selectOnly(_db.transactionsTb)
                ..where(_db.transactionsTb.transactionCategoryId.equals(id))
                ..addColumns([_db.transactionsTb.id.count()]))
              .getSingle();

      final count = txCount.read(_db.transactionsTb.id.count()) ?? 0;

      if (count > 0) {
        throw CategoryInUseException('Cannot delete category: $count transaction(s) still using it');
      }

      // Safe to delete
      final deleted = await (_db.delete(_db.transactionCategoryTb)..where((t) => t.id.equals(id))).go();

      if (deleted > 0) {
        clearCache();
      }

      return deleted > 0;
    } catch (e) {
      logger.e('Error deleting category: $e');
      rethrow;
    }
  }

  // ✅ NEW: Check if category can be deleted
  Future<bool> canDeleteCategory(int id) async {
    try {
      final txCount =
          await (_db.selectOnly(_db.transactionsTb)
                ..where(_db.transactionsTb.transactionCategoryId.equals(id))
                ..addColumns([_db.transactionsTb.id.count()]))
              .getSingle();

      final count = txCount.read(_db.transactionsTb.id.count()) ?? 0;
      return count == 0;
    } catch (e) {
      logger.e('Error checking category: $e');
      return false;
    }
  }
}

// ========== MODELS ==========

class SeparatedCategories {
  final List<TransactionCategory> expense;
  final List<TransactionCategory> income;
  final List<TransactionCategory> transfer;

  const SeparatedCategories({required this.expense, required this.income, required this.transfer});
}

// ✅ NEW: Custom exception
class CategoryInUseException implements Exception {
  final String message;
  CategoryInUseException(this.message);

  @override
  String toString() => 'CategoryInUseException: $message';
}
