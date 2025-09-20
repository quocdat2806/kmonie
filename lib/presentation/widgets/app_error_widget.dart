import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/ui_constants.dart';
import 'package:kmonie/core/text_styles/app_text_styles.dart';

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
            color: AppColors.red,
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
