import 'package:dartz/dartz.dart';
import 'exception.dart';
import 'failure.dart';

typedef EitherFailureOr<T> = Either<Failure, T>;

Future<EitherFailureOr<T>> guardFuture<T>(Future<T> Function() run) async {
  try {
    final T result = await run();
    return right(result);
  } on Failure catch (f) {
    return left(f);
  } on CacheException catch (e) {
    return left(CacheFailure(e.message));
  }
}

EitherFailureOr<T> guardSync<T>(T Function() run) {
  try {
    final T result = run();
    return right(result);
  } on Failure catch (f) {
    return left(f);
  } on CacheException catch (e) {
    return left(CacheFailure(e.message));
  }
}
