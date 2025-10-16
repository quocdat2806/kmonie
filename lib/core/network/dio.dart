import 'package:dio/dio.dart';
import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/core/services/secure_storage.dart';
import 'auth_header_interceptor.dart';
import 'logging_interceptor.dart';
import 'network_guard_interceptor.dart';
import 'network_info.dart';
import 'retry_interceptor.dart';

abstract class AppDio {
  Dio get dio;
}

class TranslationDio extends AppDio {
  TranslationDio({required NetworkInfo networkInfo, required SecureStorageService secure, required LoggingInterceptor logging}) : _networkInfo = networkInfo, _secure = secure, _logging = logging {
    _dio = _build();
  }

  final NetworkInfo _networkInfo;
  final SecureStorageService _secure;
  final LoggingInterceptor _logging;
  late final Dio _dio;

  @override
  Dio get dio => _dio;

  Dio _build() {
    final Dio d = Dio(
      BaseOptions(
        baseUrl: AppConfigs.baseUrl,
        headers: const <String, dynamic>{'Content-Type': 'application/json', 'Accept': 'application/json'},
        connectTimeout: const Duration(milliseconds: AppConfigs.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConfigs.receiveTimeout),
      ),
    );

    final RetryInterceptor retry = RetryInterceptor(dio: d, retryAbleStatusCodes: <int>{502, 503, 504}, retryMethods: <String>{'GET', 'PUT', 'DELETE', 'HEAD', 'OPTIONS', 'POST'});

    d.interceptors.addAll(<Interceptor>[NetworkGuardInterceptor(networkInfo: _networkInfo), AuthHeaderInterceptor(secure: _secure), retry, _logging]);

    return d;
  }
}
