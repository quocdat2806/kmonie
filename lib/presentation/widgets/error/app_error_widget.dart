import 'package:flutter/material.dart';

import '../../../../core/exports.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  const AppErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: UIConstants.extraLargeIconSize,
            color: ColorConstants.red,
          ),
          const SizedBox(height: UIConstants.defaultSpacing),
          Text(
            message,
            style: AppTextStyle.redS14,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
