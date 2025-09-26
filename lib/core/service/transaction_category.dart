import 'package:kmonie/database/drift_local_database.dart';
import 'package:kmonie/entity/transaction_category/transaction_category.dart';
import 'package:kmonie/core/enum/transaction_type.dart';
import 'package:get_it/get_it.dart';

final _sl = GetIt.instance;

class TransactionCategoryService {
  TransactionCategoryService._();

  static TransactionCategoryService get I => TransactionCategoryService._();

  KMonieDatabase get _db => _sl<KMonieDatabase>();

  TransactionCategory _mapRow(TransactionCategoryTbData r) {
    return TransactionCategory(
      id: r.id,
      title: r.title,
      pathAsset: r.pathAsset,
      transactionType: TransactionType.fromIndex(r.transactionType),
    );
  }


  /// Lấy toàn bộ categories (một lần)
  Future<List<TransactionCategory>> getAll() async {
    final rows = await _db.select(_db.transactionCategoryTb).get();
    return rows.map(_mapRow).toList();
  }

  /// Lấy theo type (expense/income/transfer)
  Future<List<TransactionCategory>> getByType(TransactionType type) async {
    final q = _db.select(_db.transactionCategoryTb)
      ..where((t) => t.transactionType.equals(type.typeIndex));
    final rows = await q.get();
    return rows.map(_mapRow).toList();
  }

  /// Lấy và tách riêng thành từng list
  Future<SeparatedCategories> getSeparated() async {
    final rows = await _db.select(_db.transactionCategoryTb).get();
    final expense = <TransactionCategory>[];
    final income  = <TransactionCategory>[];
    final transfer= <TransactionCategory>[];

    for (final r in rows) {
      final e = _mapRow(r);
      switch (e.transactionType) {
        case TransactionType.expense:  expense.add(e); break;
        case TransactionType.income:   income.add(e);  break;
        case TransactionType.transfer: transfer.add(e);break;
      }
    }
    return SeparatedCategories(expense: expense, income: income, transfer: transfer);
  }

  // --------------- Streams (reactive) ---------------

  /// Stream toàn bộ categories (realtime)
  Stream<List<TransactionCategory>> watchAll() {
    return _db.select(_db.transactionCategoryTb).watch().map(
          (rows) => rows.map(_mapRow).toList(),
    );
  }

  /// Stream theo type (realtime)
  Stream<List<TransactionCategory>> watchByType(TransactionType type) {
    final q = _db.select(_db.transactionCategoryTb)
      ..where((t) => t.transactionType.equals(type.typeIndex));
    return q.watch().map((rows) => rows.map(_mapRow).toList());
  }

  /// Stream & tách list (realtime)
  Stream<SeparatedCategories> watchSeparated() {
    return _db.select(_db.transactionCategoryTb).watch().map((rows) {
      final expense = <TransactionCategory>[];
      final income  = <TransactionCategory>[];
      final transfer= <TransactionCategory>[];
      for (final r in rows) {
        final e = _mapRow(r);
        switch (e.transactionType) {
          case TransactionType.expense:  expense.add(e); break;
          case TransactionType.income:   income.add(e);  break;
          case TransactionType.transfer: transfer.add(e);break;
        }
      }
      return SeparatedCategories(expense: expense, income: income, transfer: transfer);
    });
  }
}

/// DTO tách list
class SeparatedCategories {
  final List<TransactionCategory> expense;
  final List<TransactionCategory> income;
  final List<TransactionCategory> transfer;
  const SeparatedCategories({
    required this.expense,
    required this.income,
    required this.transfer,
  });
}
