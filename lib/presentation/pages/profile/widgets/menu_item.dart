import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/ui_constants.dart';
import 'package:kmonie/core/text_styles/app_text_styles.dart';

class MenuItem extends StatelessWidget {
  final String iconAsset;
  final String title;
  const MenuItem({super.key, required this.iconAsset, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.extraLargePadding,
          vertical: UIConstants.defaultPadding,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconAsset,
              width: UIConstants.mediumIconSize,
              height: UIConstants.mediumIconSize,
              colorFilter: const ColorFilter.mode(
                AppColors.yellow,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: UIConstants.defaultSpacing),
            Expanded(child: Text(title, style: AppTextStyle.blackS14Medium)),
            const Icon(Icons.chevron_right, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}
