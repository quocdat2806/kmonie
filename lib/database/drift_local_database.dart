import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import '../core/constant/exports.dart';

part 'drift_local_database.g.dart';

class TransactionsTb extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get amount => integer()();

  DateTimeColumn get date => dateTime()();

  IntColumn get transactionCategoryId => integer().references(
    TransactionCategoryTb,
    #id,
    onDelete: KeyAction.restrict,
  )();

  TextColumn get content => text().withDefault(const Constant(''))();

  IntColumn get transactionType => integer().withDefault(const Constant(0))();
}

class TransactionCategoryTb extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get pathAsset => text().withDefault(const Constant(''))();

  IntColumn get transactionType => integer().withDefault(const Constant(0))();

  BoolColumn get isCategoryDefaultSystem =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get isCreateNewCategory =>
      boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [TransactionsTb, TransactionCategoryTb])
class KMonieDatabase extends _$KMonieDatabase {
  static KMonieDatabase? _instance;
  factory KMonieDatabase() {
    _instance ??= KMonieDatabase._create();
    return _instance!;
  }

  KMonieDatabase._create() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await customStatement('PRAGMA page_size=4096;');
      await migrator.createAll();
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions_tb (date);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_transactions_category ON transactions_tb (transaction_category_id);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_category_type ON transaction_category_tb (transaction_type);',
      );
      await _seedSystemCategoriesIfEmpty();
    },
    onUpgrade: (migrator, from, to) async {},
  );

  Future<void> warmUp() async {
    await customSelect('SELECT 1').get();
    await customStatement('PRAGMA journal_mode=WAL');
    await customStatement('PRAGMA synchronous=NORMAL');
    await customStatement('PRAGMA foreign_keys=ON');
    await customStatement('PRAGMA optimize;');
    await customStatement('PRAGMA auto_vacuum=INCREMENTAL;');
    await customStatement('VACUUM;');
    await customStatement('PRAGMA wal_checkpoint(TRUNCATE);');
  }

  Future<bool> isDatabaseFileExists() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/kmonie.sqlite');
    return await file.exists();
  }

  Future<int> dbPhysicalSizeBytes() async {
    final dir = await getApplicationDocumentsDirectory();
    final base = '${dir.path}/kmonie.sqlite';
    final files = [File(base), File('$base-wal'), File('$base-shm')];
    int total = 0;
    for (final f in files) {
      if (await f.exists()) {
        total += await f.length();
      }
    }
    return total;
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
            isCreateNewCategory: Value(cat.isCreateNewCategory),
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
