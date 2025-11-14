import 'package:dartz/dartz.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/error/error.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/entities/entities.dart';

abstract class TransactionCategoryRepository {
  Future<Either<Failure, List<TransactionCategory>>> getAll({
    bool forceRefresh,
  });
  Future<Either<Failure, List<TransactionCategory>>> getByType(
    TransactionType type,
  );
  Future<Either<Failure, SeparatedCategories>> getSeparated({
    bool forceRefresh,
  });

  void clearCache();
}

class TransactionCategoryRepositoryImpl
    implements TransactionCategoryRepository {
  TransactionCategoryRepositoryImpl(this._categoryService);

  final TransactionCategoryService _categoryService;

  @override
  Future<Either<Failure, List<TransactionCategory>>> getAll({
    bool forceRefresh = false,
  }) async {
    try {
      final categories = await _categoryService.getAll(
        forceRefresh: forceRefresh,
      );
      return Right(categories);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionCategory>>> getByType(
    TransactionType type,
  ) async {
    try {
      final categories = await _categoryService.getByType(type);
      return Right(categories);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SeparatedCategories>> getSeparated({
    bool forceRefresh = false,
  }) async {
    try {
      final separated = await _categoryService.getSeparated(
        forceRefresh: forceRefresh,
      );
      return Right(separated);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  void clearCache() {
    _categoryService.clearCache();
  }
}
