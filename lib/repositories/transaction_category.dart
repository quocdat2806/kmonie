import 'package:dartz/dartz.dart';
import 'package:kmonie/core/error/failure.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/utils/logger.dart';

abstract class TransactionCategoryRepository {
  Stream<List<TransactionCategory>> watchAll();

  Future<Either<Failure, List<TransactionCategory>>> getAll({bool forceRefresh});

  Future<Either<Failure, TransactionCategory?>> getCategoryById(int id);

  Future<Either<Failure, List<TransactionCategory>>> getByType(TransactionType type);

  Future<Either<Failure, SeparatedCategories>> getSeparated({bool forceRefresh});

  Stream<List<TransactionCategory>> watchByType(TransactionType type);

  Stream<SeparatedCategories> watchSeparated();

  Future<Either<Failure, TransactionCategory>> createCategory({required String title, required String pathAsset, required TransactionType transactionType, bool isCreateNewCategory});

  Future<Either<Failure, TransactionCategory?>> updateCategory({required int id, String? title, String? pathAsset});

  Future<Either<Failure, bool>> deleteCategory(int id);

  Future<Either<Failure, bool>> canDeleteCategory(int id);

  void clearCache();
}

class TransactionCategoryRepositoryImpl implements TransactionCategoryRepository {
  TransactionCategoryRepositoryImpl(this._categoryService);

  final TransactionCategoryService _categoryService;

  @override
  Stream<List<TransactionCategory>> watchAll() {
    return _categoryService.watchAll();
  }

  @override
  Future<Either<Failure, List<TransactionCategory>>> getAll({bool forceRefresh = false}) async {
    try {
      final categories = await _categoryService.getAll(forceRefresh: forceRefresh);
      logger.d('TransactionCategoryRepositoryImpl: Categories: $categories');
      return Right(categories);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionCategory?>> getCategoryById(int id) async {
    try {
      final category = await _categoryService.getCategoryById(id);
      return Right(category);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionCategory>>> getByType(TransactionType type) async {
    try {
      final categories = await _categoryService.getByType(type);
      return Right(categories);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SeparatedCategories>> getSeparated({bool forceRefresh = false}) async {
    try {
      final separated = await _categoryService.getSeparated(forceRefresh: forceRefresh);
      return Right(separated);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Stream<List<TransactionCategory>> watchByType(TransactionType type) {
    return _categoryService.watchByType(type);
  }

  @override
  Stream<SeparatedCategories> watchSeparated() {
    return _categoryService.watchSeparated();
  }

  @override
  Future<Either<Failure, TransactionCategory>> createCategory({required String title, required String pathAsset, required TransactionType transactionType, bool isCreateNewCategory = true}) async {
    try {
      final category = await _categoryService.createCategory(title: title, pathAsset: pathAsset, transactionType: transactionType, isCreateNewCategory: isCreateNewCategory);
      return Right(category);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionCategory?>> updateCategory({required int id, String? title, String? pathAsset}) async {
    try {
      final category = await _categoryService.updateCategory(id: id, title: title, pathAsset: pathAsset);
      return Right(category);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCategory(int id) async {
    try {
      final result = await _categoryService.deleteCategory(id);
      return Right(result);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> canDeleteCategory(int id) async {
    try {
      final result = await _categoryService.canDeleteCategory(id);
      return Right(result);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }

  @override
  void clearCache() {
    _categoryService.clearCache();
  }
}
