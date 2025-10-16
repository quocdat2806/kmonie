import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/entities/auth_response/auth_response.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: AppConfigs.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @POST('/auth/signUp')
  Future<AuthResponse> register({@Field('userName') required String username, @Field('passWord') required String password});

  @POST('/auth/signIn')
  Future<AuthResponse> signIn({@Field('userName') required String username, @Field('passWord') required String password});
}
