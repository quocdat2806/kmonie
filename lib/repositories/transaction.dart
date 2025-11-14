import 'package:dartz/dartz.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/error/error.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/args/args.dart';
import 'package:kmonie/core/config/config.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Transaction>> createTransaction({
    required int amount,
    required DateTime date,
    required int transactionCategoryId,
    String content,
    required int transactionType,
  });

  Future<Either<Failure, Transaction?>> getTransactionById(int id);

  Future<Either<Failure, Transaction?>> updateTransaction({
    required int id,
    int? amount,
    DateTime? date,
    int? transactionCategoryId,
    String? content,
  });

  Future<Either<Failure, bool>> deleteTransaction(int id);

  Future<Either<Failure, List<Transaction>>> getAllTransactions();

  Future<Either<Failure, PagedTransactionResult>> getTransactionsInMonth({
    required int year,
    required int month,
    int pageSize,
    int pageIndex,
  });

  Future<Either<Failure, List<Transaction>>> getTransactionsInYear(
    int year, {
    bool forceRefresh,
  });

  Future<Either<Failure, PagedTransactionResult>> searchByContent({
    String? keyword,
    int? transactionType,
    int pageSize,
    int pageIndex,
  });

  Map<String, List<Transaction>> groupByDate(List<Transaction> transactions);

  DailyTransactionTotal calculateDailyTotal(List<Transaction> transactions);

  Future<Either<Failure, int>> getSpentAmountForCategory({
    required int categoryId,
    required int year,
    required int month,
  });

  Stream<List<Transaction>> watchTransactions();

  Stream<List<Transaction>> watchTransactionsByCategory(int categoryId);

  void clearYearCache([int? year]);

  void clearAllGroupCache();

  Future<Either<Failure, List<MonthlyArgs>>> getAllMonthlyStatistics({
    int? year,
  });
}

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._transactionService);

  final TransactionService _transactionService;

  @override
  Future<Either<Failure, Transaction>> createTransaction({
    required int amount,
    required DateTime date,
    required int transactionCategoryId,
    String content = '',
    required int transactionType,
  }) async {
    try {
      final transaction = await _transactionService.createTransaction(
        amount: amount,
        date: date,
        transactionCategoryId: transactionCategoryId,
        content: content,
        transactionType: transactionType,
      );
      return Right(transaction);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction?>> getTransactionById(int id) async {
    try {
      final transaction = await _transactionService.getTransactionById(id);
      return Right(transaction);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction?>> updateTransaction({
    required int id,
    int? amount,
    DateTime? date,
    int? transactionCategoryId,
    String? content,
  }) async {
    try {
      final transaction = await _transactionService.updateTransaction(
        id: id,
        amount: amount,
        date: date,
        transactionCategoryId: transactionCategoryId,
        content: content,
      );
      return Right(transaction);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTransaction(int id) async {
    try {
      final result = await _transactionService.deleteTransaction(id);
      return Right(result);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getAllTransactions() async {
    try {
      final transactions = await _transactionService.getAllTransactions();
      return Right(transactions);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PagedTransactionResult>> getTransactionsInMonth({
    required int year,
    required int month,
    int pageSize = AppConfigs.defaultPageSize,
    int pageIndex = AppConfigs.defaultPageIndex,
  }) async {
    try {
      final result = await _transactionService.getTransactionsInMonth(
        year: year,
        month: month,
        pageSize: pageSize,
        pageIndex: pageIndex,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsInYear(
    int year, {
    bool forceRefresh = false,
  }) async {
    try {
      final transactions = await _transactionService.getTransactionsInYear(
        year,
        forceRefresh: forceRefresh,
      );
      return Right(transactions);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PagedTransactionResult>> searchByContent({
    String? keyword,
    int? transactionType,
    int pageSize = AppConfigs.defaultPageSize,
    int pageIndex = AppConfigs.defaultPageIndex,
  }) async {
    try {
      final result = await _transactionService.searchByContent(
        keyword: keyword,
        transactionType: transactionType,
        pageSize: pageSize,
        pageIndex: pageIndex,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Map<String, List<Transaction>> groupByDate(List<Transaction> transactions) {
    return _transactionService.groupByDate(transactions);
  }

  @override
  Future<Either<Failure, int>> getSpentAmountForCategory({
    required int categoryId,
    required int year,
    required int month,
  }) async {
    try {
      final range = AppDateUtils.monthRangeUtc(year, month);
      final allTransactions = await _transactionService.getAllTransactions();

      final startLocal = range.startUtc.toLocal();
      final endLocal = range.endUtc.toLocal();

      final spentAmount = allTransactions
          .where(
            (t) =>
                t.transactionCategoryId == categoryId &&
                t.transactionType == TransactionType.expense.typeIndex &&
                !t.date.isBefore(startLocal) &&
                t.date.isBefore(endLocal),
          )
          .fold<int>(0, (sum, t) => sum + t.amount);

      return Right(spentAmount);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return _transactionService.watchTransactions();
  }

  @override
  Stream<List<Transaction>> watchTransactionsByCategory(int categoryId) {
    return _transactionService.watchTransactionsByCategory(categoryId);
  }

  @override
  void clearYearCache([int? year]) {
    _transactionService.clearYearCache(year);
  }

  @override
  void clearAllGroupCache() {
    _transactionService.clearAllGroupCache();
  }

  @override
  DailyTransactionTotal calculateDailyTotal(List<Transaction> transactions) {
    return TransactionCalculator.calculateDailyTotal(transactions);
  }

  @override
  Future<Either<Failure, List<MonthlyArgs>>> getAllMonthlyStatistics({
    int? year,
  }) async {
    try {
      final allTransactions = await _transactionService.getAllTransactions();

      final transactions = year != null
          ? allTransactions.where((t) => t.date.year == year).toList()
          : allTransactions;

      final Map<String, MonthlyArgs> monthlyAggMap = {};

      for (final transaction in transactions) {
        final key = '${transaction.date.year}-${transaction.date.month}';
        final existing =
            monthlyAggMap[key] ??
            MonthlyArgs(
              year: transaction.date.year,
              month: transaction.date.month,
            );
        if (transaction.transactionType == TransactionType.income.typeIndex) {
          monthlyAggMap[key] = MonthlyArgs(
            year: existing.year,
            month: existing.month,
            income: existing.income + transaction.amount.toDouble(),
            expense: existing.expense,
          );
        } else if (transaction.transactionType ==
            TransactionType.expense.typeIndex) {
          monthlyAggMap[key] = MonthlyArgs(
            year: existing.year,
            month: existing.month,
            income: existing.income,
            expense: existing.expense + transaction.amount.toDouble(),
          );
        }
      }

      final result = monthlyAggMap.values.toList();
      return Right(
        result..sort((a, b) {
          final yearCompare = b.year.compareTo(a.year);
          if (yearCompare != 0) return yearCompare;
          return b.month.compareTo(a.month);
        }),
      );
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }
}
