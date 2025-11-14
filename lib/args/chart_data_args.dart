import 'dart:ui';

import 'package:kmonie/entities/entities.dart';

class ChartDataArgs {
  final String label;
  final double value;
  final Color color;
  final List<String>? gradientColors;
  final TransactionCategory? category;

  ChartDataArgs(
    this.label,
    this.value,
    this.color, {
    this.gradientColors,
    this.category,
  });
}
