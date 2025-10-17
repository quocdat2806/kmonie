import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/entities/entities.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: AppConfigs.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @POST('/auth/signUp')
  Future<AuthResponse> signUp({@Field('userName') required String userName, @Field('password') required String passWord});

  @POST('/auth/signIn')
  Future<AuthResponse> signIn({@Field('userName') required String userName, @Field('password') required String passWord});
}
