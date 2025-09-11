import 'package:flutter/material.dart';

abstract class AppInputTheme {
  const AppInputTheme._();

  static const Color _fieldBorder = Color(0xFFE6EBF0);
  static const Color _hint = Color(0xFF9AA6B2);

  static OutlineInputBorder _border([Color c = _fieldBorder]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: c),
      );

  static final InputDecorationTheme defaultInput = InputDecorationTheme(
    isDense: true,
    hintStyle: const TextStyle(color: _hint),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    enabledBorder: _border(),
    focusedBorder: _border(const Color(0xFFCBD5E1)),
    filled: true,
    fillColor: const Color(0xFFF8FAFC),
  );
}
