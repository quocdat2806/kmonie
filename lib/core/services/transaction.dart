import 'package:drift/drift.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/entity/entity.dart';
import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/core/utils/utils.dart';

class PagedTransactionResult {
  final List<Transaction> transactions;
  final int totalRecords;

  PagedTransactionResult({required this.transactions, required this.totalRecords});
}

class TransactionService {
  final KMonieDatabase _db;

  // ✅ FIX: LRU cache với size limit
  final _LRUCache<String, Map<String, List<Transaction>>> _groupCache = _LRUCache(maxSize: 10); // Chỉ giữ 10 tháng gần nhất

  // ✅ FIX: Year cache + invalidation tracking
  final Map<int, List<Transaction>> _yearCache = {};
  final Set<int> _dirtyYears = {}; // Track years cần refresh

  TransactionService(this._db);

  Transaction _mapRow(TransactionsTbData row) {
    return Transaction(id: row.id, amount: row.amount, date: row.date.toLocal(), transactionCategoryId: row.transactionCategoryId, content: row.content, transactionType: row.transactionType);
  }

  Expression<bool> _dateInRange(Expression<DateTime> dateCol, DateTime start, DateTime end) {
    return dateCol.isBiggerOrEqualValue(start) & dateCol.isSmallerThanValue(end);
  }

  // ✅ Helper: Invalidate all caches
  void _invalidateAllCaches([int? transactionYear]) {
    _groupCache.clear();

    if (transactionYear != null) {
      _yearCache.remove(transactionYear);
      _dirtyYears.add(transactionYear);
    } else {
      _yearCache.clear();
      _dirtyYears.clear();
    }
  }

  Future<Transaction> createTransaction({required int amount, required DateTime date, required int transactionCategoryId, String content = '', required int transactionType}) async {
    try {
      final utc = date.toUtc();

      final id = await _db.into(_db.transactionsTb).insert(TransactionsTbCompanion.insert(amount: amount, date: utc, transactionCategoryId: transactionCategoryId, content: Value(content), transactionType: Value(transactionType)));

      // ✅ FIX: Invalidate cache after create
      _invalidateAllCaches(date.year);

      return Transaction(id: id, amount: amount, date: utc.toLocal(), transactionCategoryId: transactionCategoryId, content: content, transactionType: transactionType);
    } catch (e) {
      logger.e('Error creating transaction: $e');
      rethrow;
    }
  }

  String _buildCacheKey(List<Transaction> list) => list.map((e) => e.id).join(',');

  Map<String, List<Transaction>> groupByDate(List<Transaction> transactions) {
    final key = _buildCacheKey(transactions);
    final cached = _groupCache.get(key);
    if (cached != null) return cached;

    final Map<String, List<Transaction>> grouped = {};
    for (final tx in transactions) {
      final dateKey = AppDateUtils.formatDateKey(tx.date);
      grouped.putIfAbsent(dateKey, () => []).add(tx);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final sortedGrouped = {for (final k in sortedKeys) k: grouped[k]!};

    _groupCache.put(key, sortedGrouped); // ✅ LRU auto-evicts oldest
    return sortedGrouped;
  }

  // ✅ REMOVED: invalidateGroupCacheForTransaction (không cần nữa)

  // ✅ FIX: Add pagination
  Future<PagedTransactionResult> searchByContent({String? keyword, int? transactionType, int pageSize = AppConfigs.defaultPageSize, int pageIndex = AppConfigs.defaultPageIndex}) async {
    try {
      // Count query
      final countExp = _db.transactionsTb.id.count();
      final countQ = _db.selectOnly(_db.transactionsTb)..addColumns([countExp]);

      if (keyword?.trim().isNotEmpty == true) {
        final like = '%${keyword!.trim()}%';
        countQ.where(_db.transactionsTb.content.like(like));
      }
      if (transactionType != null) {
        countQ.where(_db.transactionsTb.transactionType.equals(transactionType));
      }

      final totalRecords = (await countQ.getSingle()).read(countExp) ?? 0;

      // Data query with pagination
      final q = _db.select(_db.transactionsTb);
      if (keyword?.trim().isNotEmpty == true) {
        final like = '%${keyword!.trim()}%';
        q.where((t) => t.content.like(like));
      }
      if (transactionType != null) {
        q.where((t) => t.transactionType.equals(transactionType));
      }

      q
        ..orderBy([(t) => OrderingTerm.desc(t.date)])
        ..limit(pageSize, offset: pageIndex * pageSize);

      final rows = await q.get();
      final items = rows.map(_mapRow).toList();

      return PagedTransactionResult(transactions: items, totalRecords: totalRecords);
    } catch (e) {
      logger.e('Error searchByContent: $e');
      return PagedTransactionResult(transactions: [], totalRecords: 0);
    }
  }

  // ✅ FIX: Remove single-item cache, SQLite handles this
  Future<Transaction?> getTransactionById(int id) async {
    final row = await (_db.select(_db.transactionsTb)..where((t) => t.id.equals(id))).getSingleOrNull();

    return row != null ? _mapRow(row) : null;
  }

  Future<Transaction?> updateTransaction({required int id, int? amount, DateTime? date, int? transactionCategoryId, String? content}) async {
    try {
      // ✅ Get old transaction to know which year to invalidate
      final oldTx = await getTransactionById(id);

      final companion = TransactionsTbCompanion(amount: amount != null ? Value(amount) : const Value.absent(), date: date != null ? Value(date.toUtc()) : const Value.absent(), transactionCategoryId: transactionCategoryId != null ? Value(transactionCategoryId) : const Value.absent(), content: content != null ? Value(content) : const Value.absent());

      await (_db.update(_db.transactionsTb)..where((t) => t.id.equals(id))).write(companion);

      // ✅ Invalidate caches for affected years
      final affectedYears = <int>{};
      if (oldTx != null) affectedYears.add(oldTx.date.year);
      if (date != null) affectedYears.add(date.year);

      for (final year in affectedYears) {
        _invalidateAllCaches(year);
      }

      return await getTransactionById(id);
    } catch (e) {
      logger.e('Error updating transaction: $e');
      return null;
    }
  }

  Future<bool> deleteTransaction(int id) async {
    try {
      // ✅ Get transaction to know which year to invalidate
      final tx = await getTransactionById(id);

      final deletedRows = await (_db.delete(_db.transactionsTb)..where((t) => t.id.equals(id))).go();

      if (deletedRows > 0 && tx != null) {
        _invalidateAllCaches(tx.date.year);
      }

      return deletedRows > 0;
    } catch (e) {
      logger.e('Error deleting transaction: $e');
      return false;
    }
  }

  Future<List<Transaction>> getAllTransactions() async {
    try {
      final rows = await (_db.select(_db.transactionsTb)..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
      return rows.map(_mapRow).toList();
    } catch (e) {
      logger.e('Error getting all transactions: $e');
      return [];
    }
  }

  Future<PagedTransactionResult> getTransactionsInMonth({required int year, required int month, int pageSize = AppConfigs.defaultPageSize, int pageIndex = AppConfigs.defaultPageIndex}) async {
    try {
      final r = AppDateUtils.monthRangeUtc(year, month);

      // Count
      final totalCountExp = _db.transactionsTb.id.count();
      final totalCountQuery = _db.selectOnly(_db.transactionsTb)
        ..where(_db.transactionsTb.date.isBiggerOrEqualValue(r.startUtc) & _db.transactionsTb.date.isSmallerThanValue(r.endUtc))
        ..addColumns([totalCountExp]);

      final totalRecords = (await totalCountQuery.getSingle()).read(totalCountExp) ?? 0;

      // Data
      final query = _db.select(_db.transactionsTb)
        ..where((t) => _dateInRange(t.date, r.startUtc, r.endUtc))
        ..orderBy([(t) => OrderingTerm.desc(t.date)])
        ..limit(pageSize, offset: pageIndex * pageSize);

      final rows = await query.get();
      final transactions = rows.map(_mapRow).toList();

      return PagedTransactionResult(transactions: transactions, totalRecords: totalRecords);
    } catch (e) {
      logger.e('Error getting paged transactions by month/year: $e');
      return PagedTransactionResult(transactions: [], totalRecords: 0);
    }
  }

  Future<List<Transaction>> getTransactionsInYear(int year, {bool forceRefresh = false}) async {
    // ✅ Check if year is dirty
    if (_dirtyYears.contains(year)) {
      _yearCache.remove(year);
      _dirtyYears.remove(year);
      forceRefresh = true;
    }

    if (!forceRefresh && _yearCache.containsKey(year)) {
      return _yearCache[year]!;
    }

    try {
      final r = AppDateUtils.yearRangeUtc(year);
      final rows =
          await (_db.select(_db.transactionsTb)
                ..where((t) => _dateInRange(t.date, r.startUtc, r.endUtc))
                ..orderBy([(t) => OrderingTerm.desc(t.date)]))
              .get();

      final result = rows.map(_mapRow).toList();
      _yearCache[year] = result;
      return result;
    } catch (e) {
      logger.e('Error getting transactions by year: $e');
      return [];
    }
  }

  void clearYearCache([int? year]) {
    if (year != null) {
      _yearCache.remove(year);
    } else {
      _yearCache.clear();
    }
  }

  void clearAllGroupCache() {
    _groupCache.clear();
  }

  Stream<List<Transaction>> watchTransactions() {
    return _db.select(_db.transactionsTb).watch().map((rows) => rows.map(_mapRow).toList());
  }

  Stream<List<Transaction>> watchTransactionsByCategory(int categoryId) {
    return (_db.select(_db.transactionsTb)..where((t) => t.transactionCategoryId.equals(categoryId))).watch().map((rows) => rows.map(_mapRow).toList());
  }
}

// ✅ Simple LRU Cache implementation
class _LRUCache<K, V> {
  final int maxSize;
  final Map<K, V> _cache = {};
  final List<K> _accessOrder = [];

  _LRUCache({required this.maxSize});

  V? get(K key) {
    if (!_cache.containsKey(key)) return null;

    // Move to end (most recently used)
    _accessOrder.remove(key);
    _accessOrder.add(key);
    return _cache[key];
  }

  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _accessOrder.remove(key);
    } else if (_cache.length >= maxSize) {
      // Remove least recently used
      final oldest = _accessOrder.removeAt(0);
      _cache.remove(oldest);
    }

    _cache[key] = value;
    _accessOrder.add(key);
  }

  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }
}
