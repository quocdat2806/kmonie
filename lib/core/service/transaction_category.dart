import 'package:kmonie/core/exports.dart';

import '../../database/exports.dart';
import '../../entity/exports.dart';
import '../enum/exports.dart';

class TransactionCategoryService {
  final KMonieDatabase _db;
  TransactionCategoryService(this._db);


  TransactionCategory _mapRow(TransactionCategoryTbData r) {
    return TransactionCategory(id: r.id, title: r.title, pathAsset: r.pathAsset, transactionType: TransactionType.fromIndex(r.transactionType));
  }

  Future<List<TransactionCategory>> getAll() async {
    final rows = await _db.select(_db.transactionCategoryTb).get();
    return rows.map(_mapRow).toList();
  }

  Future<List<TransactionCategory>> getByType(TransactionType type) async {
    try {
      final q = _db.select(_db.transactionCategoryTb)
        ..where((t) => t.transactionType.equals(type.typeIndex));
      final rows = await q.get();
      return rows.map(_mapRow).toList();
    } catch (e) {
      logger.e('error $e');
      return [];
    }
  }

  Future<SeparatedCategories> getSeparated() async {
    final rows = await _db.select(_db.transactionCategoryTb).get();
    final expense = <TransactionCategory>[];
    final income = <TransactionCategory>[];
    final transfer = <TransactionCategory>[];

    for (final r in rows) {
      final e = _mapRow(r);
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

  Stream<List<TransactionCategory>> watchAll() {
    return _db.select(_db.transactionCategoryTb).watch().map((rows) => rows.map(_mapRow).toList());
  }

  Stream<List<TransactionCategory>> watchByType(TransactionType type) {
    final q = _db.select(_db.transactionCategoryTb)..where((t) => t.transactionType.equals(type.typeIndex));
    return q.watch().map((rows) => rows.map(_mapRow).toList());
  }

  Stream<SeparatedCategories> watchSeparated() {
    return _db.select(_db.transactionCategoryTb).watch().map((rows) {
      final expense = <TransactionCategory>[];
      final income = <TransactionCategory>[];
      final transfer = <TransactionCategory>[];
      for (final r in rows) {
        final e = _mapRow(r);
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
