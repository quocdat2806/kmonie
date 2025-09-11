import 'package:flutter/material.dart';
import 'package:kmonie/core/configs/app_configs.dart';
import 'package:kmonie/core/constants/color_constants.dart';

class AppTextStyle {
  AppTextStyle._();

  static const TextStyle primary = TextStyle(color: AppColors.primary);
  static final TextStyle primaryS12 = primary.copyWith(fontSize: 12);
  static final TextStyle primaryS12W500 = primary.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle primaryS12W700 = primary.copyWith(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle primaryS12W800 = primary.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle primaryS14 = primary.copyWith(fontSize: 14);
  static final TextStyle primaryS14W500 = primaryS14.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle primaryS14Bold = primaryS14.copyWith(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle primaryS14W700 = primaryS14.copyWith(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle primaryS14W800 = primaryS14.copyWith(
    fontWeight: FontWeight.w800,
  );
  static const TextStyle black = TextStyle(color: AppColors.textBlack);

  static final TextStyle blackS12 = black.copyWith(fontSize: 12);
  static final TextStyle blackS12Medium = blackS12.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle blackS12Bold = blackS12.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle blackS12W800 = blackS12.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle blackS14 = black.copyWith(fontSize: 14);
  static final TextStyle blackS14W500 = blackS14.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle blackS14W700 = blackS14.copyWith(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle blackS14W800 = blackS14.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle blackS16 = black.copyWith(fontSize: 16);
  static final TextStyle blackS16W500 = blackS16.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final TextStyle blackS16W700 = blackS16.copyWith(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle blackS16W800 = blackS16.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle blackS18 = black.copyWith(fontSize: 18);
  static final TextStyle blackS18Bold = blackS18.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle blackS18W500 = blackS18.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle blackS18W700 = blackS18.copyWith(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle blackS18W800 = blackS18.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle blackS20 = black.copyWith(fontSize: 20);
  static final TextStyle blackS20Bold = blackS20.copyWith(
    fontWeight: FontWeight.w400,
  );
  static final TextStyle blackS20W700 = blackS20.copyWith(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle blackS20W800 = blackS20.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle blackS24 = black.copyWith(fontSize: 24);
  static final TextStyle blackS24Bold = blackS24.copyWith(
    fontWeight: FontWeight.w400,
  );
  static final TextStyle blackS24W700 = blackS24.copyWith(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle blackS24W800 = blackS24.copyWith(
    fontWeight: FontWeight.w800,
  );

  static const TextStyle grey = TextStyle(
    color: AppColors.grey,
    fontWeight: FontWeight.w400,
    fontFamily: AppConfigs.fontFamily,
  );

  static final TextStyle greyS12 = grey.copyWith(fontSize: 12);
  static final TextStyle greyS12Bold = greyS12.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle greyS12W700 = greyS12.copyWith(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle greyS12W800 = greyS12.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle greyS14 = grey.copyWith(fontSize: 14);
  static final TextStyle greyS14Bold = greyS14.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle greyS14W200 = greyS14.copyWith(
    fontWeight: FontWeight.w200,
  );

  static final TextStyle greyS14W700 = greyS14.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle greyS14W800 = greyS14.copyWith(
    fontWeight: FontWeight.w800,
  );

  static const TextStyle blue = TextStyle(
    color: AppColors.secondary,
    fontWeight: FontWeight.w400,
    fontFamily: AppConfigs.fontFamily,
  );

  static final TextStyle blueS12 = blue.copyWith(fontSize: 12);
  static final TextStyle blueS12Medium = blueS12.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle blueS12Bold = blueS12.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle blueS12W800 = blueS12.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle blueS14 = blue.copyWith(fontSize: 14);
  static final TextStyle blueS14Medium = blueS14.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle blueS14Bold = blueS14.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle blueS14W800 = blueS14.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle blueS16 = blue.copyWith(fontSize: 16);
  static final TextStyle blueS16Bold = blueS16.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle blueS16W600 = blueS16.copyWith(
    fontWeight: FontWeight.w600,
  );
  static final TextStyle blueS16W800 = blueS16.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle blueS18 = blue.copyWith(fontSize: 18);
  static final TextStyle blueS18Bold = blueS18.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle blueS18W700 = blueS18.copyWith(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle blueS18W800 = blueS18.copyWith(
    fontWeight: FontWeight.w800,
  );

  static const TextStyle blue1 = TextStyle(
    color: AppColors.blue,
    fontWeight: FontWeight.w400,
    fontFamily: AppConfigs.fontFamily,
  );

  static final TextStyle blue1S12 = blue1.copyWith(fontSize: 12);
  static final TextStyle blue1S12Medium = blue1S12.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle blue1S12Bold = blue1S12.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle blue1S12W800 = blue1S12.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle blue1S14 = blue1.copyWith(fontSize: 14);
  static final TextStyle blue1S14Medium = blue1S14.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle blue1S14Bold = blue1S14.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle blue1S14W800 = blue1S14.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle blue1S16 = blue1.copyWith(fontSize: 16);
  static final TextStyle blue1S16Bold = blue1S16.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle blue1S16W600 = blue1S16.copyWith(
    fontWeight: FontWeight.w600,
  );
  static final TextStyle blue1S16W800 = blue1S16.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle blue1S18 = blue1.copyWith(fontSize: 18);
  static final TextStyle blue1S18Bold = blue1S18.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle blue1S18W700 = blue1S18.copyWith(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle blue1S18W800 = blue1S18.copyWith(
    fontWeight: FontWeight.w800,
  );

  static const TextStyle red = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w400,
    fontFamily: AppConfigs.fontFamily,
  );

  static final TextStyle redS10 = red.copyWith(fontSize: 10);
  static final TextStyle redS10Bold = redS10.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle redS10W800 = redS10.copyWith(
    fontWeight: FontWeight.w800,
  );
  static final TextStyle redS10W700 = redS10.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle redS12 = red.copyWith(fontSize: 12);
  static final TextStyle redS12Bold = redS12.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle redS12W800 = redS12.copyWith(
    fontWeight: FontWeight.w800,
  );
  static final TextStyle redS12W700 = redS12.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle redS14 = red.copyWith(fontSize: 14);
  static final TextStyle redS14Bold = redS14.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle redS14W800 = redS14.copyWith(
    fontWeight: FontWeight.w800,
  );
  static final TextStyle redS14W700 = redS14.copyWith(
    fontWeight: FontWeight.w700,
  );

  static const TextStyle white = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontFamily: AppConfigs.fontFamily,
  );

  static final TextStyle whiteS10 = white.copyWith(fontSize: 10);
  static final TextStyle whiteS10Bold = whiteS10.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle whiteS10W800 = whiteS10.copyWith(
    fontWeight: FontWeight.w800,
  );
  static final TextStyle whiteS10W700 = whiteS10.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle whiteS12 = white.copyWith(fontSize: 12);
  static final TextStyle whiteS12Bold = whiteS12.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle whiteS12W800 = whiteS12.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle whiteS14 = white.copyWith(fontSize: 14);
  static final TextStyle whiteS14Bold = whiteS14.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle whiteS14W800 = whiteS14.copyWith(
    fontWeight: FontWeight.w800,
  );
  static final TextStyle whiteS14W700 = whiteS14.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle whiteS16 = white.copyWith(fontSize: 16);
  static final TextStyle whiteS16Bold = whiteS16.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle whiteS16W800 = whiteS16.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle whiteS18 = white.copyWith(fontSize: 18);
  static final TextStyle whiteS18Bold = whiteS18.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle whiteS18W800 = whiteS18.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle whiteS20 = white.copyWith(fontSize: 20);
  static final TextStyle whiteS20Bold = whiteS20.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle whiteS20W800 = whiteS20.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle whiteS24 = white.copyWith(fontSize: 24);
  static final TextStyle whiteS24Bold = whiteS24.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle whiteS24W800 = whiteS24.copyWith(
    fontWeight: FontWeight.w800,
  );

  static const TextStyle gray = TextStyle(
    color: AppColors.textGray,
    fontWeight: FontWeight.w400,
    fontFamily: AppConfigs.fontFamily,
  );

  static final TextStyle grayS10 = gray.copyWith(fontSize: 10);
  static final TextStyle grayS10Medium = grayS10.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle grayS10Bold = grayS10.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle grayS10W800 = grayS10.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle grayS12 = gray.copyWith(fontSize: 12);
  static final TextStyle grayS12Medium = grayS12.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle grayS12Bold = grayS12.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle grayS12W800 = grayS12.copyWith(
    fontWeight: FontWeight.w800,
  );
  static final TextStyle grayS12W700 = grayS12.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle grayS14 = gray.copyWith(fontSize: 14);
  static final TextStyle grayS14Medium = grayS14.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle grayS14Bold = grayS14.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle grayS14W800 = grayS14.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle grayS16 = gray.copyWith(fontSize: 16);
  static final TextStyle grayS16Bold = grayS16.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle grayS16W800 = grayS16.copyWith(
    fontWeight: FontWeight.w800,
  );

  static final TextStyle grayS18 = gray.copyWith(fontSize: 18);
  static final TextStyle grayS18Bold = grayS18.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle grayS18W800 = grayS18.copyWith(
    fontWeight: FontWeight.w800,
  );

  static const TextStyle yellowBold = TextStyle(
    color: AppColors.yellowBold,
    fontWeight: FontWeight.w400,
    fontFamily: AppConfigs.fontFamily,
  );
  static final TextStyle yellowBoldS10 = yellowBold.copyWith(fontSize: 10);
  static final TextStyle yellowBoldS10Bold = yellowBoldS10.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle yellowBoldS10W700 = yellowBoldS10.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle yellowBoldS12 = yellowBold.copyWith(fontSize: 14);
  static final TextStyle yellowBoldS12Bold = yellowBoldS12.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle yellowBoldS12W700 = yellowBoldS12.copyWith(
    fontWeight: FontWeight.w700,
  );

  static const TextStyle yellowThin = TextStyle(
    color: AppColors.yellowThin,
    fontWeight: FontWeight.w400,
    fontFamily: AppConfigs.fontFamily,
  );
  static final TextStyle yellowThinS12 = yellowThin.copyWith(fontSize: 12);
  static final TextStyle yellowThinS12Bold = yellowThinS12.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle yellowThinS12W700 = yellowThinS12.copyWith(
    fontWeight: FontWeight.w700,
  );

  static const TextStyle green = TextStyle(
    color: AppColors.green,
    fontWeight: FontWeight.w400,
    fontFamily: AppConfigs.fontFamily,
  );
  static final TextStyle greenS12 = green.copyWith(fontSize: 12);

  static final TextStyle greenS14 = green.copyWith(fontSize: 14);
  static final TextStyle greenS14Bold = greenS14.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle greenS14BoldW700 = greenS14.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle greenS16 = green.copyWith(fontSize: 16);
  static final TextStyle greenS16Bold = greenS16.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle greenS16BoldW700 = greenS16.copyWith(
    fontWeight: FontWeight.w700,
  );

  static final TextStyle greenS18 = green.copyWith(fontSize: 18);
  static final TextStyle greenS18Bold = greenS18.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final TextStyle greenS18BoldW700 = greenS18.copyWith(
    fontWeight: FontWeight.w700,
  );
}
