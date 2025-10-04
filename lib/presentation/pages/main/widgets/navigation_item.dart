import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constant/export.dart';
import '../../../../core/text_style/export.dart';

class MainNavigationItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String iconPath;
  final String label;
  final VoidCallback? onTap;

  const MainNavigationItem({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.iconPath,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == currentIndex;
    final Color iconColor = isActive ? ColorConstants.primary : ColorConstants.white;
    final TextStyle textStyle = isActive
        ? AppTextStyle.yellowS10
        : AppTextStyle.whiteS10;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          spacing:UIConstants.extraSmallSpacing,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: UIConstants.defaultIconSize,
              height: UIConstants.defaultIconSize,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            Text(label, style: textStyle),
          ],
        ),
      ),
    );
  }
}
