import 'package:dartz/dartz.dart';
import 'package:kmonie/core/error/error.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/entities/entities.dart';

abstract class AccountRepository {
  Future<Either<Failure, List<Account>>> getAllAccounts();
  Future<Either<Failure, Account>> createAccount(Account account);
  Future<Either<Failure, Account>> updateAccount(Account account);
  Future<Either<Failure, void>> deleteAccount(int accountId);
  Future<Either<Failure, Account?>> getPinnedAccount();
  Future<Either<Failure, void>> pinAccount(int accountId);
  Future<Either<Failure, void>> unpinAccount(int accountId);
  Future<Either<Failure, void>> updateAccountBalance(
    int accountId,
    int newBalance,
  );
  Stream<List<Account>> watchAccounts();
}

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._accountService);

  final AccountService _accountService;

  @override
  Future<Either<Failure, List<Account>>> getAllAccounts() async {
    try {
      final accounts = await _accountService.getAllAccounts();
      return Right(accounts);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Account>> createAccount(Account account) async {
    try {
      final createdAccount = await _accountService.createAccount(account);
      return Right(createdAccount);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Account>> updateAccount(Account account) async {
    try {
      final updatedAccount = await _accountService.updateAccount(account);
      return Right(updatedAccount);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(int accountId) async {
    try {
      await _accountService.deleteAccount(accountId);
      return const Right(null);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Account?>> getPinnedAccount() async {
    try {
      final account = await _accountService.getPinnedAccount();
      return Right(account);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> pinAccount(int accountId) async {
    try {
      await _accountService.pinAccount(accountId);
      return const Right(null);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unpinAccount(int accountId) async {
    try {
      await _accountService.unpinAccount(accountId);
      return const Right(null);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAccountBalance(
    int accountId,
    int newBalance,
  ) async {
    try {
      await _accountService.updateAccountBalance(accountId, newBalance);
      return const Right(null);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Stream<List<Account>> watchAccounts() {
    return _accountService.watchAccounts();
  }
}
