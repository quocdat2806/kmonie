import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constant/export.dart';
import '../../core/enum/export.dart';

class SvgConstants {
  SvgConstants._();

  static Widget icon({required String assetPath, SvgSizeType size = SvgSizeType.defaultSize, Color? color}) {
    final double iconSize = switch (size) {
      SvgSizeType.small => UIConstants.smallIconSize,
      SvgSizeType.medium => UIConstants.mediumIconSize,
      SvgSizeType.large => UIConstants.largeIconSize,
      SvgSizeType.extra => UIConstants.extraLargeIconSize,
      _ => UIConstants.defaultIconSize,
    };

    return SvgPicture.asset(assetPath, width: iconSize, height: iconSize, colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : const ColorFilter.mode(ColorConstants.black, BlendMode.srcIn));
  }
}
