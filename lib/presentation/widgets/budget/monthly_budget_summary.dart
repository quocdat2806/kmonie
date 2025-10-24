import 'package:flutter/material.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';

class MonthlyBudgetSummary extends StatelessWidget {
  const MonthlyBudgetSummary({super.key, required this.monthlyBudget, required this.totalSpent, this.useOverBudgetColors = false, this.alignRight = true});

  final int monthlyBudget;
  final int totalSpent;
  final bool useOverBudgetColors;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final int remaining = monthlyBudget - totalSpent;
    final double progress = monthlyBudget > 0 ? (totalSpent / monthlyBudget).clamp(0.0, 1.0) : 0.0;
    final bool isOverBudget = remaining < 0 || (useOverBudgetColors && totalSpent > 0 && monthlyBudget == 0);
    final backgroundColor = isOverBudget && useOverBudgetColors ? AppColorConstants.red : AppColorConstants.primary;
    final valueColor = isOverBudget && useOverBudgetColors ? AppColorConstants.red.withValues(alpha: 0.7) : AppColorConstants.grey;
    final percentage = isOverBudget ? '100.0%' : '${(isOverBudget ? (progress * 100) : (100 - progress * 100)).toStringAsFixed(1)}%';
    return Row(
      spacing: AppUIConstants.defaultSpacing,
      children: [
        SizedBox(
          width: AppUIConstants.chartPieSizeSmall,
          height: AppUIConstants.chartPieSizeSmall,
          child: Stack(
            children: [
              Transform.rotate(
                angle: 0,
                child: SizedBox(
                  width: AppUIConstants.chartPieSizeSmall,
                  height: AppUIConstants.chartPieSizeSmall,
                  child: CircularProgressIndicator(value: progress, strokeWidth: AppUIConstants.chartPieStrokeWidthSmall, backgroundColor: backgroundColor, valueColor: AlwaysStoppedAnimation<Color>(valueColor), strokeCap: StrokeCap.butt),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(isOverBudget ? AppTextConstants.overBudget : AppTextConstants.remaining, style: AppTextStyle.blackS12Medium),
                    Text(percentage, style: AppTextStyle.blackS12Medium),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            spacing: AppUIConstants.smallSpacing,
            crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              _buildBudgetInfoItem('${AppTextConstants.remaining} :', FormatUtils.formatCurrency(remaining.abs()), isOverBudget: remaining < 0, isNegative: remaining < 0),
              _buildBudgetInfoItem('${AppTextConstants.budget} :', FormatUtils.formatCurrency(monthlyBudget)),
              _buildBudgetInfoItem('${AppTextConstants.spent} :', FormatUtils.formatCurrency(totalSpent), isOverBudget: remaining < 0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetInfoItem(String label, String value, {bool isOverBudget = false, bool isNegative = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.blackS12Medium),
        Text(isNegative ? '-$value' : value, style: AppTextStyle.blackS12.copyWith(color: isOverBudget ? AppColorConstants.red : AppColorConstants.black)),
      ],
    );
  }
}
