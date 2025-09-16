import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/text_constants.dart';
import 'package:kmonie/core/constants/ui_constants.dart';
import 'package:kmonie/core/navigation/app_navigation.dart';
import 'package:kmonie/core/text_styles/app_text_styles.dart';

class AddTransactionHeader extends StatelessWidget {
  const AddTransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _handleCancel(context),
            child: Text(
              TextConstants.cancelButtonText,
              style: AppTextStyle.blackS14Medium,
            ),
          ),
          Text(
            TextConstants.addTransactionTitle,
            style: AppTextStyle.blackS18Bold,
          ),
          const ColoredBox(
            color: AppColors.white,
            child: Icon(
              Icons.checklist,
              color: AppColors.black,
              size: UIConstants.defaultIconSize,
            ),
          ),
        ],
      ),
    );
  }

  void _handleCancel(BuildContext context) {
    AppNavigator(context: context).pop();
  }
}
