import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import '../core/constant/transaction_category.dart';
part 'drift_local_database.g.dart';

class TransactionsTb extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  IntColumn get transactionCategoryId =>
      integer().withDefault(const Constant(0))();
  TextColumn get content => text().withDefault(const Constant(''))();
}

class TransactionCategoryTb extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get pathAsset => text().withDefault(const Constant(''))();
  IntColumn get transactionType => integer().withDefault(const Constant(0))();
  BoolColumn get isCategoryDefaultSystem=>boolean().withDefault(const Constant(true))();
}
@DriftDatabase(tables: [TransactionsTb,TransactionCategoryTb])
class KMonieDatabase extends _$KMonieDatabase {
  KMonieDatabase._internal() : super(_openConnection());

  static final KMonieDatabase _instance = KMonieDatabase._internal();

  factory KMonieDatabase() => _instance;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
    },
  );

  Future<void> warmUp() async {
    await customSelect('SELECT 1').get();
    _seedSystemCategoriesIfEmpty();
  }
  Future<bool> isDatabaseFileExists() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/kmonie.sqlite');
    return await file.exists();
  }

  Future<void> _seedSystemCategoriesIfEmpty() async {
    final countRow = await customSelect(
      'SELECT COUNT(*) AS c FROM transaction_category_tb',
    ).getSingle();
    final c = (countRow.data['c'] as int?) ?? 0;
    if (c > 0) return;
    final all = TransactionCategoryConstants.transactionCategorySystem;
    await batch((b) {
      for (final cat in all) {
        b.insert(
          transactionCategoryTb,
          TransactionCategoryTbCompanion.insert(
            title: cat.title,
            pathAsset: Value(cat.pathAsset),
            transactionType: Value(cat.transactionType.typeIndex),
            isCategoryDefaultSystem: const Value(true),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }


}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File('${dir.path}/kmonie.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}
