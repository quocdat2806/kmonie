import 'package:flutter/material.dart';
import 'package:kmonie/core/text_style/text_style.dart';

class WeekdayHeader extends StatelessWidget {
  const WeekdayHeader({super.key});

  static const _weekdays = [
    'CN',
    'Th 2',
    'Th 3',
    'Th 4',
    'Th 5',
    'Th 6',
    'Th 7',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: _weekdays
            .map(
              (day) => Expanded(
                child: Center(child: Text(day, style: AppTextStyle.blackS12)),
              ),
            )
            .toList(),
      ),
    );
  }
}
