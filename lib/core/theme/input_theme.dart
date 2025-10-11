import 'package:flutter/material.dart';

import 'package:kmonie/core/constants/constants.dart';

abstract class AppInputTheme {
  const AppInputTheme._();

  static OutlineInputBorder _border([
    Color c = AppColorConstants.borderInput,
  ]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppUIConstants.smallBorderRadius),
    borderSide: BorderSide(color: c),
  );

  static final InputDecorationTheme defaultInput = InputDecorationTheme(
    isDense: true,
    hintStyle: const TextStyle(color: AppColorConstants.hintInput),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppUIConstants.defaultSpacing,
      vertical: AppUIConstants.smallPadding,
    ),
    enabledBorder: _border(),
    focusedBorder: _border(AppColorConstants.focusInput),
    filled: true,
    fillColor: AppColorConstants.fillInput,
  );
}
