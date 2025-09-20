import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/text_constants.dart';
import 'package:kmonie/core/navigation/app_navigation.dart';
import 'package:kmonie/core/text_styles/app_text_styles.dart';
import 'package:kmonie/generated/assets.dart';

class AddTransactionHeader extends StatelessWidget {
  const AddTransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
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
          InkWell(
            onTap: () {},
            child: DecoratedBox(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.divider,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(Assets.svgsChecklist),
              ),
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
