import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'drift_local_database.g.dart';

class TransactionsTb extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  IntColumn get transactionCategoryId =>
      integer().withDefault(const Constant(0))();
  TextColumn get content => text().withDefault(const Constant(''))();
}

@DriftDatabase(tables: [TransactionsTb])
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
  }
  Future<bool> isDatabaseFileExists() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/kmonie.sqlite');
    return await file.exists();
  }

}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File('${dir.path}/kmonie.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}
