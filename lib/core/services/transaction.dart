import 'package:drift/drift.dart';
import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/entities/entities.dart';

class TransactionService {
  final KMonieDatabase _db;
  final AccountService _accountService;
  TransactionService(this._db, this._accountService);

  final LRUCache<String, Map<String, List<Transaction>>> _groupCache = LRUCache(
    maxSize: 30,
  );

  final Map<int, List<Transaction>> _yearCache = {};
  final Set<int> _dirtyYears = {};

  Transaction _mapRow(TransactionsTbData row) {
    return Transaction(
      id: row.id,
      amount: row.amount,
      date: row.date.toLocal(),
      transactionCategoryId: row.transactionCategoryId,
      content: row.content,
      transactionType: row.transactionType,
      createdAt: row.createdAt.toLocal(),
      updatedAt: row.updatedAt.toLocal(),
    );
  }

  Expression<bool> _dateInMonthRange(
    Expression<DateTime> dateCol,
    int year,
    int month,
  ) {
    final r = AppDateUtils.monthRangeUtc(year, month);
    return dateCol.isBiggerOrEqualValue(r.startUtc) &
        dateCol.isSmallerThanValue(r.endUtc);
  }

  Expression<bool> _dateInYearRange(Expression<DateTime> dateCol, int year) {
    final r = AppDateUtils.yearRangeUtc(year);
    return dateCol.isBiggerOrEqualValue(r.startUtc) &
        dateCol.isSmallerThanValue(r.endUtc);
  }

  Future<int> calculateTotalAmountInMonth({
    required int year,
    required int month,
    int? transactionType,
    int? categoryId,
  }) async {
    final transactions = await _getTransactionsInMonth(
      year,
      month,
      transactionType,
      categoryId,
    );
    return TransactionCalculator.calculateTotalAmount(transactions);
  }

  Future<int> calculateTotalAmountInYear({
    required int year,
    int? transactionType,
    int? categoryId,
  }) async {
    final transactions = await _getTransactionsInYear(
      year,
      transactionType,
      categoryId,
    );
    return TransactionCalculator.calculateTotalAmount(transactions);
  }

  Future<List<TransactionsTbData>> getTransactionsFiltered({
    int? year,
    int? month,
    int? transactionType,
    int? categoryId,
    int? limit,
    int? offset,
  }) async {
    final q = _db.select(_db.transactionsTb);

    if (year != null && month != null) {
      q.where((t) => _dateInMonthRange(t.date, year, month));
    }
    if (year != null) {
      q.where((t) => _dateInYearRange(t.date, year));
    }

    if (transactionType != null) {
      q.where((t) => t.transactionType.equals(transactionType));
    }

    if (categoryId != null) {
      q.where((t) => t.transactionCategoryId.equals(categoryId));
    }

    q.orderBy([(t) => OrderingTerm.desc(t.date)]);

    if (limit != null) {
      q.limit(limit, offset: offset ?? 0);
    }

    return await q.get();
  }

  Future<List<Transaction>> _getTransactionsInMonth(
    int year,
    int month,
    int? transactionType,
    int? categoryId,
  ) async {
    final q = _db.select(_db.transactionsTb)
      ..where((t) => _dateInMonthRange(t.date, year, month));

    if (transactionType != null) {
      q.where((t) => t.transactionType.equals(transactionType));
    }

    if (categoryId != null) {
      q.where((t) => t.transactionCategoryId.equals(categoryId));
    }

    final rows = await q.get();
    return rows.map(_mapRow).toList();
  }

  Future<List<Transaction>> _getTransactionsInYear(
    int year,
    int? transactionType,
    int? categoryId,
  ) async {
    final q = _db.select(_db.transactionsTb)
      ..where((t) => _dateInYearRange(t.date, year));

    if (transactionType != null) {
      q.where((t) => t.transactionType.equals(transactionType));
    }

    if (categoryId != null) {
      q.where((t) => t.transactionCategoryId.equals(categoryId));
    }

    final rows = await q.get();
    return rows.map(_mapRow).toList();
  }

  void _invalidateAllCaches([int? transactionYear]) {
    _groupCache.clear();

    if (transactionYear != null) {
      _yearCache.remove(transactionYear);
      _dirtyYears.add(transactionYear);
      return;
    }
    _yearCache.clear();
    _dirtyYears.clear();
  }

  Future<Transaction> createTransaction({
    required int amount,
    required DateTime date,
    required int transactionCategoryId,
    String content = '',
    required int transactionType,
  }) async {
    try {
      final utc = date.toUtc();

      final id = await _db
          .into(_db.transactionsTb)
          .insert(
            TransactionsTbCompanion.insert(
              amount: amount,
              date: utc,
              transactionCategoryId: transactionCategoryId,
              content: Value(content),
              transactionType: Value(transactionType),
            ),
          );

      _invalidateAllCaches(date.year);

      await _updatePinnedAccountBalance(amount, transactionType);

      return Transaction(
        id: id,
        amount: amount,
        date: utc.toLocal(),
        transactionCategoryId: transactionCategoryId,
        content: content,
        transactionType: transactionType,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      logger.e('Error creating transaction: $e');
      rethrow;
    }
  }

  Future<void> _updatePinnedAccountBalance(
    int amount,
    int transactionType,
  ) async {
    try {
      final pinnedAccount = await _accountService.getPinnedAccount();

      if (pinnedAccount != null && pinnedAccount.id != null) {
        int newBalance = pinnedAccount.balance;
        if (transactionType == TransactionType.expense.typeIndex) {
          newBalance -= amount;
        } else if (transactionType == TransactionType.income.typeIndex) {
          newBalance += amount;
        }

        await _accountService.updateAccountBalance(
          pinnedAccount.id!,
          newBalance,
        );
        logger.i(
          'Updated pinned account balance: ${pinnedAccount.name} -> $newBalance VND',
        );
      }
    } catch (e) {
      logger.e('Error updating pinned account balance: $e');
    }
  }

  String _buildCacheKey(List<Transaction> list) =>
      list.map((e) => e.id).join(',');

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

    _groupCache.put(key, sortedGrouped);
    return sortedGrouped;
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

      final totalRecords = (await countQ.getSingle()).read(countExp) ?? 0;

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

      return PagedTransactionResult(
        transactions: items,
        totalRecords: totalRecords,
      );
    } catch (e) {
      logger.e('Error searchByContent: $e');
      return PagedTransactionResult(transactions: [], totalRecords: 0);
    }
  }

  Future<Transaction?> getTransactionById(int id) async {
    final row = await (_db.select(
      _db.transactionsTb,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

    return row != null ? _mapRow(row) : null;
  }

  Future<Transaction?> updateTransaction({
    required int id,
    int? amount,
    DateTime? date,
    int? transactionCategoryId,
    String? content,
  }) async {
    try {
      final oldTx = await getTransactionById(id);

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
      final tx = await getTransactionById(id);

      final deletedRows = await (_db.delete(
        _db.transactionsTb,
      )..where((t) => t.id.equals(id))).go();

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
      final totalCountExp = _db.transactionsTb.id.count();
      final totalCountQuery = _db.selectOnly(_db.transactionsTb)
        ..where(_dateInMonthRange(_db.transactionsTb.date, year, month))
        ..addColumns([totalCountExp]);

      final totalRecords =
          (await totalCountQuery.getSingle()).read(totalCountExp) ?? 0;

      final query = _db.select(_db.transactionsTb)
        ..where((t) => _dateInMonthRange(t.date, year, month))
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

  Future<List<Transaction>> getTransactionsInYear(
    int year, {
    bool forceRefresh = false,
  }) async {
    if (_dirtyYears.contains(year)) {
      _yearCache.remove(year);
      _dirtyYears.remove(year);
      forceRefresh = true;
    }

    if (!forceRefresh && _yearCache.containsKey(year)) {
      return _yearCache[year]!;
    }

    try {
      final rows =
          await (_db.select(_db.transactionsTb)
                ..where((t) => _dateInYearRange(t.date, year))
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
      return;
    }
    _yearCache.clear();
  }

  void clearAllGroupCache() {
    _groupCache.clear();
  }

  Future<Map<int, int>> getSpentAmountsByCategoryForMonth({
    required int year,
    required int month,
  }) async {
    final transactions = await _getTransactionsInMonth(
      year,
      month,
      TransactionType.expense.typeIndex,
      null,
    );

    final Map<int, int> result = {};
    for (final tx in transactions) {
      result[tx.transactionCategoryId] =
          (result[tx.transactionCategoryId] ?? 0) + tx.amount;
    }

    return result;
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
