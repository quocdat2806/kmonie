import 'dart:math';

import 'package:flutter/material.dart';

class GradientHelper {
  static LinearGradient fromColorHexList(List<String> hexColors) {
    final colors = hexColors.map(_colorFromHex).toList();
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static List<String> generateSmartGradientColors() {
    final random = Random();

    final baseHue = random.nextDouble() * 360;
    final baseSaturation = 0.6 + random.nextDouble() * 0.4;
    final baseLightness = 0.45 + random.nextDouble() * 0.25;
    final baseColor = HSLColor.fromAHSL(
      1,
      baseHue,
      baseSaturation,
      baseLightness,
    ).toColor();

    final hueOffset =
        (random.nextBool() ? 1 : -1) * (15 + random.nextDouble() * 15);
    final secondHue = (baseHue + hueOffset) % 360;
    final secondLightness = (baseLightness + (random.nextDouble() * 0.1 - 0.05))
        .clamp(0.3, 0.8);
    final secondSaturation =
        (baseSaturation + (random.nextDouble() * 0.1 - 0.05)).clamp(0.5, 1.0);
    final secondColor = HSLColor.fromAHSL(
      1,
      secondHue,
      secondSaturation,
      secondLightness,
    ).toColor();

    return [_colorToHex(baseColor), _colorToHex(secondColor)];
  }

  static Color generateCategoryColor(int categoryId) {
    final double hue = (categoryId * 37) % 360.0;
    const double saturation = 0.65;
    const double lightness = 0.55;
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  static Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String _colorToHex(Color color) {
    final argb = color.toARGB32();
    return '#${argb.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}
