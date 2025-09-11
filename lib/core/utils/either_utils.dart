import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kmonie/core/error/dio_error_mapper.dart';
import 'package:kmonie/core/error/exceptions.dart';
import 'package:kmonie/core/error/failures.dart';

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
    return left(ServerFailure(message: e.message));
  } on CacheException catch (e) {
    return left(CacheFailure(message: e.message));
  } on NetworkException catch (e) {
    return left(NetworkFailure(message: e.message));
  } catch (e) {
    return left(ServerFailure(message: e.toString()));
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
    return left(ServerFailure(message: e.message));
  } on CacheException catch (e) {
    return left(CacheFailure(message: e.message));
  } on NetworkException catch (e) {
    return left(NetworkFailure(message: e.message));
  } catch (e) {
    return left(ServerFailure(message: e.toString()));
  }
}
