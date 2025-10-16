import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kmonie/core/error/failure.dart';
import 'package:kmonie/core/network/api_client.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/enums/enums.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> authenticate({required String username, required String password, required AuthMode mode});
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Either<Failure, AuthResponse>> authenticate({required String username, required String password, required AuthMode mode}) async {
    try {
      final response = mode == AuthMode.signIn ? await _apiClient.signIn(username: username, password: password) : await _apiClient.register(username: username, password: password);
      return Right(response);
    } on DioException catch (e) {
      return Left(Failure.server(e.message ?? 'Server error'));
    } catch (e) {
      return Left(Failure.server(e.toString()));
    }
  }
}
