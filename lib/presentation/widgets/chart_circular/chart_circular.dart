import 'dart:math' as math;

import 'package:flutter/material.dart';

class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}

class ChartCircular extends StatefulWidget {
  final List<ChartData> data;
  final double size;
  final double strokeWidth;
  final Duration duration;

  const ChartCircular({super.key, required this.data, this.size = 200, this.strokeWidth = 40, this.duration = const Duration(milliseconds: 800)});

  @override
  State<ChartCircular> createState() => _ChartCircularState();
}

class _ChartCircularState extends State<ChartCircular> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: AppChartPainter(data: widget.data, strokeWidth: widget.strokeWidth, progress: _animation.value),
            ),
          );
        },
      ),
    );
  }
}

class AppChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double strokeWidth;
  final double progress;

  late final double _total;
  late final List<double> _percentages;

  AppChartPainter({required this.data, required this.strokeWidth, required this.progress}) {
    _total = data.fold(0.0, (sum, item) => sum + item.value);
    _percentages = data.map((item) => item.value / _total).toList();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2;
    double accumulatedPercent = 0.0;

    for (int i = 0; i < data.length; i++) {
      final segmentPercent = _percentages[i];
      final sweepAngle = segmentPercent * 2 * math.pi;

      final segmentStart = accumulatedPercent;
      final visiblePercent = ((progress - segmentStart) / segmentPercent).clamp(0.0, 1.0);

      if (visiblePercent > 0) {
        final paint = Paint()
          ..color = data[i].color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt;

        canvas.drawArc(rect, startAngle, sweepAngle * visiblePercent, false, paint);
      }

      startAngle += sweepAngle;
      accumulatedPercent += segmentPercent;
    }
  }

  @override
  bool shouldRepaint(covariant AppChartPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.strokeWidth != strokeWidth || oldDelegate.data != data;
  }
}
