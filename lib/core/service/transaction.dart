import 'dart:convert';

import 'package:drift/drift.dart';

import '../../database/exports.dart';
import '../../entity/exports.dart';
import '../config/export.dart';
import '../tool/exports.dart';
import '../util/exports.dart';

class PagedTransactionResult {
  final List<Transaction> transactions;
  final int totalRecords;

  PagedTransactionResult({required this.transactions, required this.totalRecords});
}

class TransactionService {
  final KMonieDatabase _db;

  TransactionService(this._db);

  Transaction _mapRow(TransactionsTbData row) {
    return Transaction(id: row.id, amount: row.amount, gradientColors: (jsonDecode(row.gradientColorsJson) as List).map((e) => e.toString()).toList(), date: row.date.toLocal(), transactionCategoryId: row.transactionCategoryId, content: row.content, transactionType: row.transactionType);
  }

  Future<PagedTransactionResult> searchByContent({String? keyword, int? transactionType, int pageSize = AppConfigs.defaultPageSize, int pageIndex = AppConfigs.defaultPageIndex}) async {
    try {
      final countExp = _db.transactionsTb.id.count();
      final countQ = _db.selectOnly(_db.transactionsTb)..addColumns([countExp]);

      if (keyword != null && keyword.trim().isNotEmpty) {
        final like = '%${keyword.trim()}%';
        countQ.where(_db.transactionsTb.content.like(like));
      }
      if (transactionType != null) {
        countQ.where(_db.transactionsTb.transactionType.equals(transactionType));
      }

      final countRow = await countQ.getSingle();
      final total = countRow.read(countExp) ?? 0;

      final q = _db.select(_db.transactionsTb);

      if (keyword != null && keyword.trim().isNotEmpty) {
        final like = '%${keyword.trim()}%';
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

  Future<Transaction> createTransaction({required int amount, required DateTime date, required int transactionCategoryId, String content = '', required int transactionType}) async {
    try {
      final gradientColors = GradientHelper.generateSmartGradientColors();
      final utc = date.toUtc();
      final id = await _db.into(_db.transactionsTb).insert(TransactionsTbCompanion.insert(gradientColorsJson: Value(jsonEncode(gradientColors)), amount: amount, date: date.toUtc(), transactionCategoryId: transactionCategoryId, content: Value(content), transactionType: Value(transactionType)));
      return Transaction(id: id, amount: amount, gradientColors: gradientColors, date: utc.toLocal(), transactionCategoryId: transactionCategoryId, content: content, transactionType: transactionType);
    } catch (e) {
      logger.e('Error creating transaction: $e');
      rethrow;
    }
  }

  Future<Transaction?> getTransactionById(int id) async {
    try {
      final query = _db.select(_db.transactionsTb)..where((t) => t.id.equals(id));

      final row = await query.getSingleOrNull();
      return row != null ? _mapRow(row) : null;
    } catch (e) {
      logger.e('Error getting transaction by id: $e');
      return null;
    }
  }

  Future<List<Transaction>> getAllTransactions() async {
    try {
      final query = _db.select(_db.transactionsTb)..orderBy([(t) => OrderingTerm.desc(t.date)]);

      final rows = await query.get();
      return rows.map(_mapRow).toList();
    } catch (e) {
      logger.e('Error getting all transactions: $e');
      return [];
    }
  }

  Future<Transaction?> getLastTransactionInMonth(int year, int month) async {
    try {
      final r = DateUtils.monthRangeUtc(year, month);
      final query = _db.select(_db.transactionsTb)
        ..where((t) => t.date.isBiggerOrEqualValue(r.startUtc) & t.date.isSmallerThanValue(r.endUtc))
        ..orderBy([(t) => OrderingTerm.desc(t.date)])
        ..limit(1);

      final row = await query.getSingleOrNull();
      return row != null ? _mapRow(row) : null;
    } catch (e) {
      logger.e('Error getting last transaction in month: $e');
      return null;
    }
  }

  Future<List<Transaction>> getTransactionsByCategory(int categoryId) async {
    try {
      final query = _db.select(_db.transactionsTb)
        ..where((t) => t.transactionCategoryId.equals(categoryId))
        ..orderBy([(t) => OrderingTerm.desc(t.date)]);

      final rows = await query.get();
      return rows.map(_mapRow).toList();
    } catch (e) {
      logger.e('Error getting transactions by category: $e');
      return [];
    }
  }

  Future<Transaction?> updateTransaction({required int id, int? amount, DateTime? date, int? transactionCategoryId, String? content}) async {
    try {
      final companion = TransactionsTbCompanion(amount: amount != null ? Value(amount) : const Value.absent(), date: date != null ? Value(date.toUtc()) : const Value.absent(), transactionCategoryId: transactionCategoryId != null ? Value(transactionCategoryId) : const Value.absent(), content: content != null ? Value(content) : const Value.absent());

      await (_db.update(_db.transactionsTb)..where((t) => t.id.equals(id))).write(companion);

      return await getTransactionById(id);
    } catch (e) {
      logger.e('Error updating transaction: $e');
      return null;
    }
  }

  Future<bool> deleteTransaction(int id) async {
    try {
      final deletedRows = await (_db.delete(_db.transactionsTb)..where((t) => t.id.equals(id))).go();

      return deletedRows > 0;
    } catch (e) {
      logger.e('Error deleting transaction: $e');
      return false;
    }
  }

  Future<int> deleteTransactions(List<int> ids) async {
    try {
      int deletedCount = 0;
      for (final id in ids) {
        final success = await deleteTransaction(id);
        if (success) deletedCount++;
      }

      return deletedCount;
    } catch (e) {
      logger.e('Error deleting multiple transactions: $e');
      return 0;
    }
  }

  Stream<List<Transaction>> watchTransactions() {
    return _db.select(_db.transactionsTb).watch().map((List<TransactionsTbData> rows) => rows.map(_mapRow).toList());
  }

  Stream<List<Transaction>> watchTransactionsByCategory(int categoryId) {
    final query = _db.select(_db.transactionsTb)..where((t) => t.transactionCategoryId.equals(categoryId));

    return query.watch().map((List<TransactionsTbData> rows) => rows.map(_mapRow).toList());
  }

  Future<PagedTransactionResult> getTransactionsInMonth({required int year, required int month, int pageSize = AppConfigs.defaultPageSize, int pageIndex = AppConfigs.defaultPageIndex}) async {
    try {
      final r = DateUtils.monthRangeUtc(year, month);
      final totalCountExp = _db.transactionsTb.id.count();
      final totalCountQuery = _db.selectOnly(_db.transactionsTb)
        ..where(_db.transactionsTb.date.isBiggerOrEqualValue(r.startUtc) & _db.transactionsTb.date.isSmallerThanValue(r.endUtc))
        ..addColumns([totalCountExp]);
      final totalCountRow = await totalCountQuery.getSingle();
      final totalRecords = totalCountRow.read(totalCountExp) ?? 0;

      final query = _db.select(_db.transactionsTb)
        ..where((t) => t.date.isBiggerOrEqualValue(r.startUtc) & t.date.isSmallerThanValue(r.endUtc))
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

  Future<List<Transaction>> getTransactionsInYear(int year) async {
    try {
      final r = DateUtils.yearRangeUtc(year);

      final query = _db.select(_db.transactionsTb)
        ..where((t) => t.date.isBiggerOrEqualValue(r.startUtc) & t.date.isSmallerThanValue(r.endUtc))
        ..orderBy([(t) => OrderingTerm.desc(t.date)]);

      final rows = await query.get();
      return rows.map(_mapRow).toList();
    } catch (e) {
      logger.e('Error getting transactions by year: $e');
      return [];
    }
  }

  Stream<List<Transaction>> watchTransactionsInMonth({required int year, required int month}) {
    final r = DateUtils.monthRangeUtc(year, month);
    final query = _db.select(_db.transactionsTb)
      ..where((t) => t.date.isBiggerOrEqualValue(r.startUtc) & t.date.isSmallerThanValue(r.endUtc))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    return query.watch().map((List<TransactionsTbData> rows) => rows.map(_mapRow).toList());
  }

  Stream<List<Transaction>> watchTransactionsInYear(int year) {
    final r = DateUtils.yearRangeUtc(year);
    final query = _db.select(_db.transactionsTb)
      ..where((t) => t.date.isBiggerOrEqualValue(r.startUtc) & t.date.isSmallerThanValue(r.endUtc))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);

    return query.watch().map((List<TransactionsTbData> rows) => rows.map(_mapRow).toList());
  }
}
