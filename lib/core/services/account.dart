import 'package:drift/drift.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/entities/entities.dart';

class AccountService {
  AccountService(this._database);

  final KMonieDatabase _database;

  Future<List<Account>> getAllAccounts() async {
    final accounts = await _database.select(_database.accountsTb).get();
    return accounts.map((row) {
      return Account(
        id: row.id,
        name: row.name,
        type: row.type,
        amount: row.amount,
        balance: row.balance,
        accountNumber: row.accountNumber,
        bankId: row.bankId,
        isPinned: row.isPinned,
      );
    }).toList();
  }

  Future<Account> createAccount(Account account) async {
    final countExp = _database.accountsTb.id.count();
    final countRow = await (_database.selectOnly(
      _database.accountsTb,
    )..addColumns([countExp])).getSingle();
    final existingCount = countRow.read(countExp) ?? 0;
    final shouldPin = existingCount == 0;

    final companion = AccountsTbCompanion.insert(
      name: account.name,
      type: Value(account.type),
      amount: Value(account.amount),
      balance: Value(account.balance),
      accountNumber: Value(account.accountNumber),
      bankId: Value(account.bankId),
      isPinned: Value(shouldPin),
    );

    final id = await _database.into(_database.accountsTb).insert(companion);
    return account.copyWith(id: id, isPinned: shouldPin);
  }

  Future<Account> updateAccount(Account account) async {
    if (account.id == null) {
      throw Exception('Account ID is required for update');
    }

    final companion = AccountsTbCompanion(
      name: Value(account.name),
      type: Value(account.type),
      amount: Value(account.amount),
      balance: Value(account.balance),
      accountNumber: Value(account.accountNumber),
      bankId: Value(account.bankId),
      isPinned: Value(account.isPinned),
      updatedAt: Value(DateTime.now()),
    );

    await (_database.update(
      _database.accountsTb,
    )..where((tbl) => tbl.id.equals(account.id!))).write(companion);
    return account;
  }

  Future<void> deleteAccount(int accountId) async {
    await (_database.delete(
      _database.accountsTb,
    )..where((tbl) => tbl.id.equals(accountId))).go();
  }

  Future<Account?> getPinnedAccount() async {
    final query = _database.select(_database.accountsTb)
      ..where((tbl) => tbl.isPinned.equals(true));
    final row = await query.getSingleOrNull();

    if (row == null) {
      return null;
    }

    return Account(
      id: row.id,
      name: row.name,
      type: row.type,
      amount: row.amount,
      balance: row.balance,
      accountNumber: row.accountNumber,
      bankId: row.bankId,
      isPinned: row.isPinned,
    );
  }

  Future<void> pinAccount(int accountId) async {
    await (_database.update(
      _database.accountsTb,
    )..where((tbl) => tbl.id.equals(accountId))).write(
      AccountsTbCompanion(
        isPinned: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> unpinAccount(int accountId) async {
    await (_database.update(
      _database.accountsTb,
    )..where((tbl) => tbl.id.equals(accountId))).write(
      AccountsTbCompanion(
        isPinned: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateAccountBalance(int accountId, int newBalance) async {
    await (_database.update(
      _database.accountsTb,
    )..where((tbl) => tbl.id.equals(accountId))).write(
      AccountsTbCompanion(
        balance: Value(newBalance),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<Account>> watchAccounts() {
    return _database.select(_database.accountsTb).watch().map((rows) {
      return rows.map((row) {
        return Account(
          id: row.id,
          name: row.name,
          type: row.type,
          amount: row.amount,
          balance: row.balance,
          accountNumber: row.accountNumber,
          bankId: row.bankId,
          isPinned: row.isPinned,
        );
      }).toList();
    });
  }
}
