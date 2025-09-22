import 'package:dio/dio.dart';
import '../../database/exports.dart';

class AuthHeaderInterceptor extends Interceptor {
  AuthHeaderInterceptor({required this.secure});
  final SecureStorageService secure;

  static const String _key = 'token';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await secure.read(_key);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
