import 'package:flutter/material.dart';

import '../constant/export.dart';

abstract class AppInputTheme {
  const AppInputTheme._();

  static OutlineInputBorder _border([Color c = ColorConstants.borderInput]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
    borderSide: BorderSide(color: c),
  );

  static final InputDecorationTheme defaultInput = InputDecorationTheme(
    isDense: true,
    hintStyle: const TextStyle(color: ColorConstants.hintInput),
    contentPadding: const EdgeInsets.symmetric(horizontal: UIConstants.defaultSpacing, vertical: UIConstants.smallPadding),
    enabledBorder: _border(),
    focusedBorder: _border(ColorConstants.focusInput),
    filled: true,
    fillColor: ColorConstants.fillInput,
  );
}
