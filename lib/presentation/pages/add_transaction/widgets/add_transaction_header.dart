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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.defaultPadding,
        vertical: UIConstants.smallPadding + UIConstants.extraSmallSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _handleCancel(context),
            child: Text(
              TextConstants.cancelButtonText,
              style: AppTextStyle.blackS16Medium,
            ),
          ),
          Text(
            TextConstants.addTransactionTitle,
            style: AppTextStyle.blackS18Bold,
          ),
          Container(
            width: UIConstants.smallContainerSize,
            height: UIConstants.smallContainerSize,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                UIConstants.defaultBorderRadius,
              ),
            ),
            child: const Icon(
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
