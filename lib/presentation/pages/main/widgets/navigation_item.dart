import 'package:flutter/material.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';

class MainNavigationItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String iconPath;
  final String label;
  final VoidCallback? onTap;

  const MainNavigationItem({super.key, required this.index, required this.currentIndex, required this.iconPath, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == currentIndex;
    final Color iconColor = isActive ? AppColorConstants.primary : AppColorConstants.white;
    final TextStyle textStyle = isActive ? AppTextStyle.yellowS10 : AppTextStyle.whiteS10;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          spacing: AppUIConstants.extraSmallSpacing,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgUtils.icon(assetPath: iconPath, color: iconColor),
            Text(label, style: textStyle),
          ],
        ),
      ),
    );
  }
}
