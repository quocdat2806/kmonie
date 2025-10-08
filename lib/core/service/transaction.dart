import 'dart:convert';

import 'package:drift/drift.dart';

import '../../database/export.dart';
import '../../entity/export.dart';
import '../config/export.dart';
import '../tool/export.dart';
import '../util/export.dart';

class PagedTransactionResult {
  final List<Transaction> transactions;
  final int totalRecords;

  PagedTransactionResult({
    required this.transactions,
    required this.totalRecords,
  });
}

class TransactionService {
  final KMonieDatabase _db;

  Transaction? _cachedTransaction;
  int? _cachedTransactionId;

  final Map<String, Map<String, List<Transaction>>> _groupCache = {};

  final Map<int, List<Transaction>> _yearCache = {};

  TransactionService(this._db);

  Transaction _mapRow(TransactionsTbData row) {
    return Transaction(
      id: row.id,
      amount: row.amount,
      gradientColors: (jsonDecode(row.gradientColorsJson) as List)
          .map((e) => e.toString())
          .toList(),
      date: row.date.toLocal(),
      transactionCategoryId: row.transactionCategoryId,
      content: row.content,
      transactionType: row.transactionType,
    );
  }

  Expression<bool> _dateInRange(
    Expression<DateTime> dateCol,
    DateTime start,
    DateTime end,
  ) {
    return dateCol.isBiggerOrEqualValue(start) &
        dateCol.isSmallerThanValue(end);
  }

  Future<Transaction> createTransaction({
    required int amount,
    required DateTime date,
    required int transactionCategoryId,
    String content = '',
    required int transactionType,
  }) async {
    try {
      final gradientColors = GradientHelper.generateSmartGradientColors();
      final utc = date.toUtc();
      final id = await _db
          .into(_db.transactionsTb)
          .insert(
            TransactionsTbCompanion.insert(
              gradientColorsJson: Value(jsonEncode(gradientColors)),
              amount: amount,
              date: utc,
              transactionCategoryId: transactionCategoryId,
              content: Value(content),
              transactionType: Value(transactionType),
            ),
          );

      return Transaction(
        id: id,
        amount: amount,
        gradientColors: gradientColors,
        date: utc.toLocal(),
        transactionCategoryId: transactionCategoryId,
        content: content,
        transactionType: transactionType,
      );
    } catch (e) {
      logger.e('Error creating transaction: $e');
      rethrow;
    }
  }

  String _buildCacheKey(List<Transaction> list) =>
      list.map((e) => e.id).join(',');

  Map<String, List<Transaction>> groupByDate(List<Transaction> transactions) {
    final key = _buildCacheKey(transactions);
    final cached = _groupCache[key];
    if (cached != null) return cached;

    final Map<String, List<Transaction>> grouped = {};
    for (final tx in transactions) {
      final dateKey = AppDateUtils.formatDateKey(tx.date);
      grouped.putIfAbsent(dateKey, () => []).add(tx);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final sortedGrouped = {for (var k in sortedKeys) k: grouped[k]!};

    _groupCache[key] = sortedGrouped;
    return sortedGrouped;
  }

  void invalidateGroupCacheForTransaction(int id) {
    _groupCache.removeWhere(
      (_, grouped) => grouped.values.expand((e) => e).any((tx) => tx.id == id),
    );
  }

  Future<PagedTransactionResult> searchByContent({
    String? keyword,
    int? transactionType,
    int pageSize = AppConfigs.defaultPageSize,
    int pageIndex = AppConfigs.defaultPageIndex,
  }) async {
    try {
      final countExp = _db.transactionsTb.id.count();
      final countQ = _db.selectOnly(_db.transactionsTb)..addColumns([countExp]);

      if (keyword?.trim().isNotEmpty == true) {
        final like = '%${keyword!.trim()}%';
        countQ.where(_db.transactionsTb.content.like(like));
      }
      if (transactionType != null) {
        countQ.where(
          _db.transactionsTb.transactionType.equals(transactionType),
        );
      }

      final total = (await countQ.getSingle()).read(countExp) ?? 0;

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
      return PagedTransactionResult(transactions: items, totalRecords: total);
    } catch (e) {
      logger.e('Error searchByContent: $e');
      return PagedTransactionResult(transactions: [], totalRecords: 0);
    }
  }

  Future<Transaction?> getTransactionById(
    int id, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        _cachedTransactionId == id &&
        _cachedTransaction != null) {
      return _cachedTransaction;
    }

    final row = await (_db.select(
      _db.transactionsTb,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

    if (row != null) {
      _cachedTransaction = _mapRow(row);
      _cachedTransactionId = id;
    }
    return _cachedTransaction;
  }

  Future<Transaction?> updateTransaction({
    required int id,
    int? amount,
    DateTime? date,
    int? transactionCategoryId,
    String? content,
  }) async {
    try {
      final companion = TransactionsTbCompanion(
        amount: amount != null ? Value(amount) : const Value.absent(),
        date: date != null ? Value(date.toUtc()) : const Value.absent(),
        transactionCategoryId: transactionCategoryId != null
            ? Value(transactionCategoryId)
            : const Value.absent(),
        content: content != null ? Value(content) : const Value.absent(),
      );

      await (_db.update(
        _db.transactionsTb,
      )..where((t) => t.id.equals(id))).write(companion);

      invalidateGroupCacheForTransaction(id);
      return await getTransactionById(id, forceRefresh: true);
    } catch (e) {
      logger.e('Error updating transaction: $e');
      return null;
    }
  }

  Future<bool> deleteTransaction(int id) async {
    try {
      final deletedRows = await (_db.delete(
        _db.transactionsTb,
      )..where((t) => t.id.equals(id))).go();

      if (deletedRows > 0) {
        if (_cachedTransactionId == id) {
          _cachedTransaction = null;
          _cachedTransactionId = null;
        }
        invalidateGroupCacheForTransaction(id);
      }

      return deletedRows > 0;
    } catch (e) {
      logger.e('Error deleting transaction: $e');
      return false;
    }
  }

  Future<List<Transaction>> getAllTransactions() async {
    try {
      final rows = await (_db.select(
        _db.transactionsTb,
      )..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
      return rows.map(_mapRow).toList();
    } catch (e) {
      logger.e('Error getting all transactions: $e');
      return [];
    }
  }

  Future<PagedTransactionResult> getTransactionsInMonth({
    required int year,
    required int month,
    int pageSize = AppConfigs.defaultPageSize,
    int pageIndex = AppConfigs.defaultPageIndex,
  }) async {
    try {
      final r = AppDateUtils.monthRangeUtc(year, month);
      final totalCountExp = _db.transactionsTb.id.count();

      final totalCountQuery = _db.selectOnly(_db.transactionsTb)
        ..where(
          _db.transactionsTb.date.isBiggerOrEqualValue(r.startUtc) &
              _db.transactionsTb.date.isSmallerThanValue(r.endUtc),
        )
        ..addColumns([totalCountExp]);

      final totalRecords =
          (await totalCountQuery.getSingle()).read(totalCountExp) ?? 0;

      final query = _db.select(_db.transactionsTb)
        ..where((t) => _dateInRange(t.date, r.startUtc, r.endUtc))
        ..orderBy([(t) => OrderingTerm.desc(t.date)])
        ..limit(pageSize, offset: pageIndex * pageSize);

      final rows = await query.get();
      final transactions = rows.map(_mapRow).toList();

      return PagedTransactionResult(
        transactions: transactions,
        totalRecords: totalRecords,
      );
    } catch (e) {
      logger.e('Error getting paged transactions by month/year: $e');
      return PagedTransactionResult(transactions: [], totalRecords: 0);
    }
  }

  Future<Transaction?> getLastTransactionInMonth(int year, int month) async {
    try {
      final r = AppDateUtils.monthRangeUtc(year, month);
      final row =
          await (_db.select(_db.transactionsTb)
                ..where((t) => _dateInRange(t.date, r.startUtc, r.endUtc))
                ..orderBy([(t) => OrderingTerm.desc(t.date)])
                ..limit(1))
              .getSingleOrNull();
      return row != null ? _mapRow(row) : null;
    } catch (e) {
      logger.e('Error getting last transaction in month: $e');
      return null;
    }
  }

  Future<List<Transaction>> getTransactionsInYear(
    int year, {
    bool forceRefresh = false,
  }) async {
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

  void clearGroupCacheForList(List<Transaction> list) {
    _groupCache.remove(_buildCacheKey(list));
  }

  Stream<List<Transaction>> watchTransactions() {
    return _db
        .select(_db.transactionsTb)
        .watch()
        .map((rows) => rows.map(_mapRow).toList());
  }

  Stream<List<Transaction>> watchTransactionsByCategory(int categoryId) {
    return (_db.select(_db.transactionsTb)
          ..where((t) => t.transactionCategoryId.equals(categoryId)))
        .watch()
        .map((rows) => rows.map(_mapRow).toList());
  }
}
