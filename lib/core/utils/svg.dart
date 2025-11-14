import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';

class SvgUtils {
  SvgUtils._();

  static Widget icon({
    required String assetPath,
    SvgSizeType size = SvgSizeType.defaultSize,
    Color? color,
  }) {
    final double iconSize = switch (size) {
      SvgSizeType.small => AppUIConstants.smallIconSize,
      SvgSizeType.medium => AppUIConstants.mediumIconSize,
      SvgSizeType.large => AppUIConstants.largeIconSize,
      SvgSizeType.extra => AppUIConstants.extraLargeIconSize,
      SvgSizeType.extraLarge => AppUIConstants.superExtraLargeIconSize,
      _ => AppUIConstants.defaultIconSize,
    };

    return SvgPicture.asset(
      assetPath,
      width: iconSize,
      height: iconSize,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : const ColorFilter.mode(AppColorConstants.black, BlendMode.srcIn),
    );
  }
}
