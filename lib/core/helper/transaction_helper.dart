import 'package:drift/drift.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/core/utils/utils.dart';

mixin TransactionQueryHelper {
  KMonieDatabase get db;

  Expression<bool> dateInMonthRange(
    Expression<DateTime> dateCol,
    int year,
    int month,
  ) {
    final r = AppDateUtils.monthRangeUtc(year, month);
    return dateCol.isBiggerOrEqualValue(r.startUtc) &
        dateCol.isSmallerThanValue(r.endUtc);
  }

  Expression<bool> dateInYearRange(Expression<DateTime> dateCol, int year) {
    final r = AppDateUtils.yearRangeUtc(year);
    return dateCol.isBiggerOrEqualValue(r.startUtc) &
        dateCol.isSmallerThanValue(r.endUtc);
  }

  // ✅ NEW: Calculate total amount for transactions in a month
  Future<int> calculateTotalAmountInMonth({
    required int year,
    required int month,
    int? transactionType,
    int? categoryId,
  }) async {
    final q = db.select(db.transactionsTb)
      ..where((t) => dateInMonthRange(t.date, year, month));

    if (transactionType != null) {
      q.where((t) => t.transactionType.equals(transactionType));
    }

    if (categoryId != null) {
      q.where((t) => t.transactionCategoryId.equals(categoryId));
    }

    final transactions = await q.get();
    return transactions.fold<int>(0, (sum, tx) => sum + tx.amount);
  }

  Future<int> calculateTotalAmountInYear({
    required int year,
    int? transactionType,
    int? categoryId,
  }) async {
    final q = db.select(db.transactionsTb)
      ..where((t) => dateInYearRange(t.date, year));

    if (transactionType != null) {
      q.where((t) => t.transactionType.equals(transactionType));
    }

    if (categoryId != null) {
      q.where((t) => t.transactionCategoryId.equals(categoryId));
    }

    final transactions = await q.get();
    return transactions.fold<int>(0, (sum, tx) => sum + tx.amount);
  }

  Future<List<TransactionsTbData>> getTransactionsFiltered({
    int? year,
    int? month,
    int? transactionType,
    int? categoryId,
    int? limit,
    int? offset,
  }) async {
    final q = db.select(db.transactionsTb);

    if (year != null && month != null) {
      q.where((t) => dateInMonthRange(t.date, year, month));
    } else if (year != null) {
      q.where((t) => dateInYearRange(t.date, year));
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
}
