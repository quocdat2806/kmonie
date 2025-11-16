import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppUIConstants {
  AppUIConstants._();

  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  static const double extraSmallPadding = 4.0;

  static const double defaultMargin = 16.0;
  static const double smallMargin = 8.0;
  static const double largeMargin = 24.0;
  static const double extraLargeMargin = 32.0;

  static const double smallBorderRadius = 4.0;
  static const double defaultBorderRadius = 8.0;
  static const double largeBorderRadius = 12.0;
  static const double extraLargeBorderRadius = 20.0;

  static const double smallIconSize = 16.0;
  static const double defaultIconSize = 20.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 28.0;
  static const double extraLargeIconSize = 32.0;
  static const double superExtraLargeIconSize = 64.0;

  static const double defaultButtonHeight = 44.0;
  static const double smallButtonHeight = 36.0;
  static const double largeButtonHeight = 52.0;

  static const double superSmallContainerSize = 12.0;
  static const double extraSmallContainerSize = 24.0;

  static const double smallContainerSize = 32.0;
  static const double defaultContainerSize = 40.0;
  static const double mediumContainerSize = 48.0;
  static const double largeContainerSize = 60.0;
  static const double extraLargeContainerSize = 80.0;
  static const double superExtraLargeContainerSize = 150.0;

  static const double extraSmallSpacing = 4.0;
  static const double superExtraSmallSpacing = 1;
  static const double smallSpacing = 8.0;
  static const double defaultSpacing = 16.0;
  static const double largeSpacing = 24.0;

  static const int defaultGridCrossAxisCount = 4;
  static const double defaultGridChildAspectRatio = 0.7;
  static const double defaultGridCrossAxisSpacing = 8.0;
  static const double defaultGridMainAxisSpacing = 8.0;
  static const double smallGridSpacing = 4.0;

  static const int defaultMaxLines = 2;
  static const int singleLine = 1;

  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration loadMoreDebounceDuration = Duration(milliseconds: 100);
  static const Duration chartInitDuration = Duration(milliseconds: 800);

  static const double keyboardSlideRatio = 0.35;
  static const double categoryItemSizeRatio = 0.55;
  static const double categoryIconSizeRatio = 0.30;

  static const double bottomNavigationHeight = 60.0;
  static const double topAddTransactionButtonOffset = 30.0;

  static const double appBarHeight = 56.0;
  static const double superSmallHeight = 6.0;
  static const double mediumHeight = 40.0;
  static const int largeHeight = 80;

  static const double strokeWidthDefault = 20.0;
  static const double strokeWidthSmall = 8.0;
  static BoxDecoration defaultShadow({Color color = AppColorConstants.grey}) {
    return BoxDecoration(
      color: AppColorConstants.white,
      borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.4),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
