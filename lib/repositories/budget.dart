import 'package:dartz/dartz.dart';
import 'package:kmonie/core/error/error.dart';
import 'package:kmonie/core/services/services.dart';

abstract class BudgetRepository {
  Future<Either<Failure, Map<int, int>>> getBudgetsForMonth(
    int year,
    int month,
  );

  Future<Either<Failure, int>> getBudgetForCategory({
    required int year,
    required int month,
    required int categoryId,
  });

  Future<Either<Failure, void>> setBudgetForCategory({
    required int year,
    required int month,
    required int categoryId,
    required int amount,
  });

  Future<Either<Failure, int>> getMonthlyBudget({
    required int year,
    required int month,
  });

  Future<Either<Failure, void>> setMonthlyBudget({
    required int year,
    required int month,
    required int amount,
  });

  Future<Either<Failure, int>> getTotalSpentForMonth({
    required int year,
    required int month,
  });

  Future<Either<Failure, int>> getSpentForCategory({
    required int year,
    required int month,
    required int categoryId,
  });

  Future<Either<Failure, int>> getTotalIncomeForMonth({
    required int year,
    required int month,
  });

  Future<Either<Failure, int>> getIncomeForCategory({
    required int year,
    required int month,
    required int categoryId,
  });

  Future<
    Either<Failure, Map<int, ({int budget, int spent, double percentUsed})>>
  >
  getBudgetComparison({required int year, required int month});

  Future<Either<Failure, ({int income, int expense, int balance})>>
  getMonthlySummary({required int year, required int month});

  Future<Either<Failure, ({List<dynamic> transactions, int totalSpent})>>
  getCategoryBreakdown({
    required int year,
    required int month,
    required int categoryId,
  });
}

class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._budgetService);

  final BudgetService _budgetService;

  @override
  Future<Either<Failure, Map<int, int>>> getBudgetsForMonth(
    int year,
    int month,
  ) async {
    try {
      final budgets = await _budgetService.getBudgetsForMonth(year, month);
      return Right(budgets);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getBudgetForCategory({
    required int year,
    required int month,
    required int categoryId,
  }) async {
    try {
      final budget = await _budgetService.getBudgetForCategory(
        year: year,
        month: month,
        categoryId: categoryId,
      );
      return Right(budget);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setBudgetForCategory({
    required int year,
    required int month,
    required int categoryId,
    required int amount,
  }) async {
    try {
      await _budgetService.setBudgetForCategory(
        year: year,
        month: month,
        categoryId: categoryId,
        amount: amount,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getMonthlyBudget({
    required int year,
    required int month,
  }) async {
    try {
      final budget = await _budgetService.getMonthlyBudget(
        year: year,
        month: month,
      );
      return Right(budget);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setMonthlyBudget({
    required int year,
    required int month,
    required int amount,
  }) async {
    try {
      await _budgetService.setMonthlyBudget(
        year: year,
        month: month,
        amount: amount,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalSpentForMonth({
    required int year,
    required int month,
  }) async {
    try {
      final spent = await _budgetService.getTotalSpentForMonth(
        year: year,
        month: month,
      );
      return Right(spent);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getSpentForCategory({
    required int year,
    required int month,
    required int categoryId,
  }) async {
    try {
      final spent = await _budgetService.getSpentForCategory(
        year: year,
        month: month,
        categoryId: categoryId,
      );
      return Right(spent);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalIncomeForMonth({
    required int year,
    required int month,
  }) async {
    try {
      final income = await _budgetService.getTotalIncomeForMonth(
        year: year,
        month: month,
      );
      return Right(income);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getIncomeForCategory({
    required int year,
    required int month,
    required int categoryId,
  }) async {
    try {
      final income = await _budgetService.getIncomeForCategory(
        year: year,
        month: month,
        categoryId: categoryId,
      );
      return Right(income);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<
    Either<Failure, Map<int, ({int budget, int spent, double percentUsed})>>
  >
  getBudgetComparison({required int year, required int month}) async {
    try {
      final comparison = await _budgetService.getBudgetComparison(
        year: year,
        month: month,
      );
      return Right(comparison);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({int income, int expense, int balance})>>
  getMonthlySummary({required int year, required int month}) async {
    try {
      final summary = await _budgetService.getMonthlySummary(
        year: year,
        month: month,
      );
      return Right(summary);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({List<dynamic> transactions, int totalSpent})>>
  getCategoryBreakdown({
    required int year,
    required int month,
    required int categoryId,
  }) async {
    try {
      final breakdown = await _budgetService.getCategoryBreakdown(
        year: year,
        month: month,
        categoryId: categoryId,
      );
      return Right(breakdown);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }
}
