import 'package:flutter/material.dart';
import '../constant/exports.dart';
import '../navigation/exports.dart';

class AppDialogs {
  AppDialogs._();

  static Future<void> showError(
    BuildContext context, {
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(TextConstants.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => AppNavigator(context: context).pop(),
            child: const Text(TextConstants.gotIt),
          ),
        ],
      ),
    );
  }

  static Future<void> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(TextConstants.cancel),
          ),
          TextButton(
            onPressed: () {
              AppNavigator(context: context).pop();
              onConfirm();
            },
            child: const Text(TextConstants.confirm),
          ),
        ],
      ),
    );
  }
}
