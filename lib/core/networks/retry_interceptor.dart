import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxAttempts = 3,
    this.retryAbleErrors = const <DioExceptionType>{
      DioExceptionType.connectionTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.connectionError,
    },
    this.retryAbleStatusCodes = const <int>{},
    this.delayBuilder,
    this.retryMethods = const <String>{'GET', 'PUT', 'DELETE', 'HEAD', 'OPTIONS'},
  });

  final Dio dio;
  final int maxAttempts;
  final Set<DioExceptionType> retryAbleErrors;
  final Set<int> retryAbleStatusCodes;
  final Set<String> retryMethods;

  final Duration Function(int attempt)? delayBuilder;

  Duration _delay(int attempt) {
    if (delayBuilder != null) {
      return delayBuilder!(attempt);
    }
    const List<int> steps = <int>[300, 700, 1500];
    final int base = steps[(attempt - 1).clamp(0, steps.length - 1)];
    final int jitter = math.Random().nextInt(120);
    return Duration(milliseconds: base + jitter);
  }

  bool _bodyIsRetryAble(Object? data) {
    if (data is Stream) {
      return false;
    }
    if (data is FormData && data.files.isNotEmpty) {
      return false;
    }
    return true;
  }

  bool _shouldRetry(DioException err, int attempt) {
    if (attempt >= maxAttempts) {
      return false;
    }

    final String method = err.requestOptions.method.toUpperCase();
    if (!retryMethods.contains(method)) {
      return false;
    }

    final int? code = err.response?.statusCode;
    if (code != null && retryAbleStatusCodes.isNotEmpty) {
      if (retryAbleStatusCodes.contains(code)) {
        return true;
      }
      if (code >= 400 && code < 500) {
        return false;
      }
    }

    if (retryAbleErrors.contains(err.type)) {
      return true;
    }

    return false;
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final RequestOptions req = err.requestOptions;

    final int attempt = req.extra['__retry_attempt'] as int? ?? 0;

    if (!_bodyIsRetryAble(req.data)) {
      return handler.next(err);
    }

    if (_shouldRetry(err, attempt)) {
      final int nextAttempt = attempt + 1;
      await Future<dynamic>.delayed(_delay(nextAttempt));

      try {
        final RequestOptions opts = req.copyWith(
          extra: <String, dynamic>{...req.extra, '__retry_attempt': nextAttempt},
        );

        final Response<RequestOptions> response = await dio.fetch(opts);
        return handler.resolve(response);
      } catch (e) {
        debugPrint('error$e');
      }
    }
    handler.next(err);
  }
}
