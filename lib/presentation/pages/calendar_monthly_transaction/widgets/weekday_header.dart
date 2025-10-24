import 'package:flutter/material.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/constants/constants.dart';

class WeekdayHeader extends StatelessWidget {
  const WeekdayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppUIConstants.smallSpacing),
      child: Row(
        children: List.generate(
          AppDateUtils.weekdays.length,
          (index) => Expanded(
            child: Center(child: Text(AppDateUtils.weekdays[index], style: AppTextStyle.blackS12)),
          ),
        ),
      ),
    );
  }
}
