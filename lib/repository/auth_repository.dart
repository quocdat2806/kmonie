import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:kmonie/core/error/failure.dart';
import 'package:kmonie/core/network/api_client.dart';
import 'package:kmonie/entity/auth_response/auth_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> register({
    required String username,
    required String password,
  });

  Future<Either<Failure, AuthResponse>> signIn({
    required String username,
    required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Either<Failure, AuthResponse>> register({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiClient.register(
        username: username,
        password: password,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(Failure.server(e.message ?? 'Server error'));
    } catch (e) {
      return Left(Failure.server(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiClient.signIn(
        username: username,
        password: password,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(Failure.server(e.message ?? 'Server error'));
    } catch (e) {
      return Left(Failure.server(e.toString()));
    }
  }
}
