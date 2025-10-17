import 'dart:io';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/utils/utils.dart';

part 'drift_local_database.g.dart';

class TransactionsTb extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get amount => integer()();

  DateTimeColumn get date => dateTime()();

  IntColumn get transactionCategoryId => integer().references(TransactionCategoryTb, #id, onDelete: KeyAction.restrict)();

  TextColumn get content => text().withDefault(const Constant(''))();

  IntColumn get transactionType => integer().withDefault(const Constant(0))();
}

class TransactionCategoryTb extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get pathAsset => text().withDefault(const Constant(''))();

  IntColumn get transactionType => integer().withDefault(const Constant(0))();

  BoolColumn get isCategoryDefaultSystem => boolean().withDefault(const Constant(true))();

  BoolColumn get isCreateNewCategory => boolean().withDefault(const Constant(false))();

  TextColumn get gradientColorsJson => text().withDefault(const Constant('[]'))();
}

class BudgetsTb extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get transactionCategoryId => integer().references(TransactionCategoryTb, #id, onDelete: KeyAction.cascade)();
  IntColumn get amount => integer().withDefault(const Constant(0))();
}

class MonthlyBudgetsTb extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get totalAmount => integer().withDefault(const Constant(0))();
}

class AccountsTb extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text().withDefault(const Constant('Tiết kiệm'))();
  IntColumn get amount => integer().withDefault(const Constant(0))();
  IntColumn get balance => integer().withDefault(const Constant(0))();
  TextColumn get accountNumber => text().withDefault(const Constant(''))();
  TextColumn get bankJson => text().withDefault(const Constant(''))();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [TransactionsTb, TransactionCategoryTb, BudgetsTb, MonthlyBudgetsTb, AccountsTb])
class KMonieDatabase extends _$KMonieDatabase {
  static KMonieDatabase? _instance;
  static const _walBytesThreshold = 16 * 1024 * 1024;
  static const _maintenanceIntervalDays = 7;
  static const _metaTableName = 'kmeta';
  static const _metaKeyLastMaintain = 'last_maintain_epoch_ms';
  factory KMonieDatabase() {
    _instance ??= KMonieDatabase._create();
    return _instance!;
  }

  KMonieDatabase._create() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await customStatement('PRAGMA page_size=4096');
      await customStatement('PRAGMA auto_vacuum=INCREMENTAL');
      await migrator.createAll();
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_budgets_year_month '
        'ON budgets_tb (year, month)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_monthly_budgets_year_month '
        'ON monthly_budgets_tb (year, month)',
      );

      await customStatement('CREATE INDEX IF NOT EXISTS idx_transaction_content ON transactions_tb(content)');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_transaction_type ON transactions_tb(transaction_type)');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions_tb (date)');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_transactions_category ON transactions_tb (transaction_category_id)');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_category_type ON transaction_category_tb (transaction_type)');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_transaction_type_date ON transactions_tb (transaction_type, date DESC)');
      await customStatement('CREATE UNIQUE INDEX IF NOT EXISTS idx_budget_unique_year_month ON budgets_tb (year, month, transaction_category_id)');
      await customStatement('CREATE UNIQUE INDEX IF NOT EXISTS idx_monthly_budget_unique_year_month ON monthly_budgets_tb (year, month)');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_accounts_name ON accounts_tb (name)');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_accounts_type ON accounts_tb (type)');
      await _seedSystemCategoriesIfEmpty();
    },
    onUpgrade: (migrator, from, to) async {
      // Best-effort, additive migrations for older installs
      if (from < 5) {
        try {
          await customStatement('ALTER TABLE accounts_tb ADD COLUMN is_pinned INTEGER NOT NULL DEFAULT 0');
        } catch (_) {}
        try {
          await customStatement('ALTER TABLE accounts_tb ADD COLUMN created_at TEXT DEFAULT CURRENT_TIMESTAMP');
        } catch (_) {}
        try {
          await customStatement('ALTER TABLE accounts_tb ADD COLUMN updated_at TEXT DEFAULT CURRENT_TIMESTAMP');
        } catch (_) {}
      }
    },
  );

  Future<void> warmUp() async {
    await customSelect('SELECT 1').get();
    await customStatement('PRAGMA synchronous=NORMAL');
    await _ensureMetaTable();
    await _maybeMaintainDatabase();
    await customStatement('PRAGMA optimize');
  }

  Future<void> _ensureMetaTable() async {
    await customStatement(
      'CREATE TABLE IF NOT EXISTS $_metaTableName ('
      'key TEXT PRIMARY KEY, '
      'value TEXT NOT NULL'
      ')',
    );
  }

  Future<String?> _getMeta(String key) async {
    final row = await customSelect('SELECT value FROM $_metaTableName WHERE key = ?', variables: [Variable<String>(key)]).getSingleOrNull();
    return row?.data['value'] as String?;
  }

  Future<void> _setMeta(String key, String value) async {
    await customStatement(
      'INSERT INTO $_metaTableName(key, value) VALUES(?, ?) '
      'ON CONFLICT(key) DO UPDATE SET value=excluded.value',
      [key, value],
    );
  }

  Future<int> _walFileSizeBytes() async {
    final dir = await getApplicationDocumentsDirectory();
    final base = '${dir.path}/kmonie.sqlite';
    final wal = File('$base-wal');
    if (await wal.exists()) return await wal.length();
    return 0;
  }

  Future<int> _freelistCount() async {
    final row = await customSelect('PRAGMA freelist_count').getSingle();
    final v = row.data['freelist_count'] ?? row.data.values.first;
    return (v is int) ? v : int.tryParse('$v') ?? 0;
  }

  Future<DateTime?> _lastMaintainAt() async {
    final v = await _getMeta(_metaKeyLastMaintain);
    if (v == null) return null;
    final ms = int.tryParse(v);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
  }

  Future<void> _markMaintainedNow() async {
    final nowUtc = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    await _setMeta(_metaKeyLastMaintain, nowUtc);
  }

  Future<void> _maybeMaintainDatabase() async {
    final walSize = await _walFileSizeBytes();
    final last = await _lastMaintainAt();
    final now = DateTime.now().toUtc();
    final needByTime = last == null || now.difference(last).inDays >= _maintenanceIntervalDays;
    final needByWal = walSize >= _walBytesThreshold;

    if (!needByTime && !needByWal) return;

    try {
      await customStatement('PRAGMA wal_checkpoint(TRUNCATE);');
      final freePages = await _freelistCount();
      if (freePages > 0) {
        await customStatement('PRAGMA incremental_vacuum($freePages);');
      }
      if (walSize > 64 * 1024 * 1024 || (needByTime && now.difference(last ?? now).inDays >= 90)) {
        await customStatement('VACUUM;');
        await customStatement('PRAGMA wal_checkpoint(TRUNCATE);');
      }
      await _markMaintainedNow();
    } catch (e) {
      logger.e('error $e');
    }
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
    final countRow = await customSelect('SELECT COUNT(*) AS c FROM transaction_category_tb').getSingle();
    final c = (countRow.data['c'] as int?) ?? 0;
    if (c > 0) return;
    final all = TransactionCategoryConstants.transactionCategorySystem;
    try {
      await batch((b) {
        for (final cat in all) {
          b.insert(
            transactionCategoryTb,
            TransactionCategoryTbCompanion.insert(title: cat.title, pathAsset: Value(cat.pathAsset), transactionType: Value(cat.transactionType.typeIndex), isCategoryDefaultSystem: const Value(true), isCreateNewCategory: Value(cat.isCreateNewCategory), gradientColorsJson: Value(cat.gradientColors.isEmpty ? '[]' : jsonEncode(cat.gradientColors))),
            mode: InsertMode.insertOrIgnore,
          );
        }
      });
    } catch (e) {
      logger.e('Error seeding system categories: $e');
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File('${dir.path}/kmonie.sqlite');
    return NativeDatabase.createInBackground(
      file,
      setup: (db) async {
        db
          ..execute('PRAGMA journal_mode=WAL;')
          ..execute('PRAGMA foreign_keys=ON;');
      },
    );
  });
}
