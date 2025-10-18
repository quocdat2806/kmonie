import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';

class MenuItem extends StatelessWidget {
  final String iconAsset;
  final String title;
  final VoidCallback? onTap;
  const MenuItem({super.key, required this.iconAsset, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.extraLargePadding, vertical: AppUIConstants.defaultPadding),
        child: Row(
          children: [
            SvgPicture.asset(iconAsset, width: AppUIConstants.mediumIconSize, height: AppUIConstants.mediumIconSize, colorFilter: const ColorFilter.mode(AppColorConstants.primary, BlendMode.srcIn)),
            const SizedBox(width: AppUIConstants.defaultSpacing),
            Expanded(child: Text(title, style: AppTextStyle.blackS14Medium)),
            const Icon(Icons.chevron_right, color: AppColorConstants.grey),
          ],
        ),
      ),
    );
  }
}
