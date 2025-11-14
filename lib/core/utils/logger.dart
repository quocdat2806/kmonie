import 'package:flutter/foundation.dart';

final LoggerUtils logger = LoggerUtils._();

class LoggerUtils {
  LoggerUtils._();
  void v(dynamic message, {StackTrace? stackTrace}) {
    _print('🤍 VERBOSE: $message', stackTrace: stackTrace);
  }

  void d(dynamic message, {StackTrace? stackTrace}) {
    _print('💙 DEBUG: $message', stackTrace: stackTrace);
  }

  void i(dynamic message, {StackTrace? stackTrace}) {
    _print('💚️ INFO: $message', stackTrace: stackTrace);
  }

  void w(dynamic message, {StackTrace? stackTrace}) {
    _print('💛 WARNING: $message', stackTrace: stackTrace);
  }

  void e(dynamic message, {StackTrace? stackTrace}) {
    _print('❤️ ERROR: $message', stackTrace: stackTrace);
  }

  void _print(dynamic message, {StackTrace? stackTrace}) {
    if (kDebugMode) {
      print("$message \n ${stackTrace ?? ''}");
    }
  }

  void _log(dynamic message) {
    if (kDebugMode) {
      print('$message');
    }
  }

  void log(
    dynamic message, {
    bool printFullText = false,
    StackTrace? stackTrace,
  }) {
    if (printFullText) {
      _log(message);
    } else {
      _print(message);
    }
    if (stackTrace != null) {
      _print(stackTrace);
    }
  }
}
