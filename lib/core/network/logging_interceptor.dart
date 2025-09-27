import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.maxBody = 5 * 1024});
  final int maxBody;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) {
      return handler.next(options);
    }
    final Map<String, dynamic> headers = Map<String, dynamic>.of(
      options.headers,
    );
    if (headers.containsKey('Authorization')) {
      headers['Authorization'] = '***';
    }
    debugPrint('➡️ ${options.method} ${options.uri}');
    debugPrint('Headers: $headers');
    if (options.data != null) {
      final String body = options.data.toString();
      debugPrint(
        'Body: ${body.length > maxBody ? '${body.substring(0, maxBody)}…' : body}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (!kDebugMode) {
      return handler.next(response);
    }
    debugPrint('✅ ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode) {
      return handler.next(err);
    }
    debugPrint(
      '❌ ${err.type} ${err.requestOptions.uri} ${err.response?.statusCode ?? ''}',
    );
    handler.next(err);
  }
}
