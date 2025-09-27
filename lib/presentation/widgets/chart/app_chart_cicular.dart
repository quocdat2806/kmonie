import 'dart:math' as math;
import 'package:flutter/material.dart';

class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}

class DonutChart extends StatefulWidget {
  final List<ChartData> data;
  final double size;
  final double strokeWidth;
  final Duration duration;

  const DonutChart({
    super.key,
    required this.data,
    this.size = 200,
    this.strokeWidth = 40,
    this.duration = const Duration(milliseconds: 800), // nhanh hơn
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward(); // bắt đầu animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: DonutChartPainter(
              data: widget.data,
              strokeWidth: widget.strokeWidth,
              progress: _animation.value,
            ),
          ),
        );
      },
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double strokeWidth;
  final double progress;

  DonutChartPainter({
    required this.data,
    required this.strokeWidth,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double total = data.fold(0, (sum, item) => sum + item.value);
    double startAngle = -math.pi / 2;
    double accumulatedPercent = 0;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].value / total) * 2 * math.pi;
      final segmentPercent = data[i].value / total;

      double segmentStart = accumulatedPercent;
      double segmentEnd = accumulatedPercent + segmentPercent;

      double visiblePercent = ((progress - segmentStart) / segmentPercent)
          .clamp(0.0, 1.0);

      final paint = Paint()
        ..color = data[i].color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle * visiblePercent,
        false,
        paint,
      );

      startAngle += sweepAngle;
      accumulatedPercent += segmentPercent;
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
