import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/entity/auth_response/auth_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: AppConfigs.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @POST('/auth/register')
  Future<AuthResponse> register({
    @Field('username') required String username,
    @Field('password') required String password,
  });

  @POST('/auth/signin')
  Future<AuthResponse> signIn({
    @Field('username') required String username,
    @Field('password') required String password,
  });
}
