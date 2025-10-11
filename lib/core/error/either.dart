import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'error_mapper.dart';
import 'exception.dart';
import 'failure.dart';

typedef EitherFailureOr<T> = Either<Failure, T>;

Future<EitherFailureOr<T>> guardFuture<T>(Future<T> Function() run) async {
  try {
    final T result = await run();
    return right(result);
  } on Failure catch (f) {
    return left(f);
  } on DioException catch (e) {
    return left(mapDioErrorToFailure(e));
  } on ServerException catch (e) {
    return left(ServerFailure(e.message));
  } on CacheException catch (e) {
    return left(CacheFailure(e.message));
  } on NetworkException catch (e) {
    return left(NetworkFailure(e.message));
  } catch (e) {
    return left(ServerFailure(e.toString()));
  }
}

EitherFailureOr<T> guardSync<T>(T Function() run) {
  try {
    final T result = run();
    return right(result);
  } on Failure catch (f) {
    return left(f);
  } on DioException catch (e) {
    return left(mapDioErrorToFailure(e));
  } on ServerException catch (e) {
    return left(ServerFailure(e.message));
  } on CacheException catch (e) {
    return left(CacheFailure(e.message));
  } on NetworkException catch (e) {
    return left(NetworkFailure(e.message));
  } catch (e) {
    return left(ServerFailure(e.toString()));
  }
}
