import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/exports.dart';
import '../../../../generated/assets.dart';

class AddTransactionHeader extends StatelessWidget {
  const AddTransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UIConstants.smallPadding),
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
                color: ColorConstants.divider,
              ),
              child: Padding(
                padding: const EdgeInsets.all(UIConstants.smallPadding),
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
