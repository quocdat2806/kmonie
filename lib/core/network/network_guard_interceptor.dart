import 'package:dio/dio.dart';
import 'network_info.dart';

class NetworkGuardInterceptor extends Interceptor {
  NetworkGuardInterceptor({required this.networkInfo});
  final NetworkInfo networkInfo;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final bool online = await networkInfo.isConnected;
    if (!online) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No internet connection',
        ),
      );
    }
    handler.next(options);
  }
}
