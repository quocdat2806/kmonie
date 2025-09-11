import 'package:dio/dio.dart';
import 'failures.dart';

String _extractMessage(dynamic data) {
  if (data == null) return '';
  try {
    if (data is String) return data;
    if (data is Map<String, dynamic>) {
      final List<String> keys = <String>['message', 'error', 'detail', 'title'];
      for (final String k in keys) {
        final dynamic v = data[k];
        if (v is String && v.trim().isNotEmpty) return v;
        if (v is List && v.isNotEmpty && v.first is String) {
          return v.first as String;
        }
      }
      final dynamic errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        for (final dynamic v in errors.values) {
          if (v is List && v.isNotEmpty) return v.first.toString();
          if (v is String && v.isNotEmpty) return v;
        }
      }
    }
  } catch (e) {
    return e.toString();
  }
  return '';
}

Failure mapDioErrorToFailure(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure(message: 'Network timeout');
    case DioExceptionType.cancel:
      return const NetworkFailure(message: 'Request cancelled');
    case DioExceptionType.badCertificate:
      return const NetworkFailure(message: 'Bad certificate');
    case DioExceptionType.badResponse:
      final int code = e.response?.statusCode ?? 0;
      final dynamic data = e.response?.data;
      final String serverMsg = _extractMessage(data);
      String message = serverMsg.isNotEmpty ? serverMsg : 'Request failed';
      if (code == 401) {
        message = serverMsg.isNotEmpty ? serverMsg : 'Unauthorized';
        return ServerFailure(message: message);
      }
      if (code == 403) {
        message = serverMsg.isNotEmpty ? serverMsg : 'Forbidden';
        return ServerFailure(message: message);
      }
      if (code == 404) {
        message = serverMsg.isNotEmpty ? serverMsg : 'Not found';
        return ServerFailure(message: message);
      }
      if (code == 409) {
        message = serverMsg.isNotEmpty ? serverMsg : 'Conflict';
        return ServerFailure(message: message);
      }
      if (code == 422) {
        message = serverMsg.isNotEmpty ? serverMsg : 'Validation error';
        return ServerFailure(message: message);
      }
      if (code >= 500) {
        message = serverMsg.isNotEmpty ? serverMsg : 'Server error';
        return ServerFailure(message: message);
      }
      return ServerFailure(message: message);
    case DioExceptionType.unknown:
      return const NetworkFailure(message: 'No Internet or unknown error');
  }
}
