import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;
  @override
  List<Object> get props => <Object>[message];
}

class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server error occurred'})
    : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache error occurred'})
    : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Network error occurred'})
    : super(message);
}
