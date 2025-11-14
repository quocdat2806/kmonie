import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';

class BudgetMonthlySection extends StatelessWidget {
  const BudgetMonthlySection({
    super.key,
    required this.moneyBudget,
    required this.totalSpent,
  });

  final int moneyBudget;
  final int totalSpent;

  @override
  Widget build(BuildContext context) {
    final int remaining = moneyBudget - totalSpent;
    final double progress = moneyBudget > 0
        ? (totalSpent / moneyBudget).clamp(0.0, 1.0)
        : 0.0;
    final bool isOverBudget = remaining < 0;
    final backgroundColor = isOverBudget
        ? AppColorConstants.red
        : AppColorConstants.primary;
    final valueColor = isOverBudget
        ? AppColorConstants.red.withValues(alpha: 0.7)
        : AppColorConstants.grey;
    final percentage = isOverBudget
        ? '100.0%'
        : '${(isOverBudget ? (progress * 100) : (100 - progress * 100)).toStringAsFixed(1)}%';
    return Row(
      spacing: AppUIConstants.defaultSpacing,
      children: [
        SizedBox(
          width: AppUIConstants.extraLargeContainerSize,
          height: AppUIConstants.extraLargeContainerSize,
          child: Stack(
            children: [
              Transform.rotate(
                angle: 0,
                child: SizedBox(
                  width: AppUIConstants.extraLargeContainerSize,
                  height: AppUIConstants.extraLargeContainerSize,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: AppUIConstants.strokeWidthSmall,
                    backgroundColor: backgroundColor,
                    valueColor: AlwaysStoppedAnimation<Color>(valueColor),
                    strokeCap: StrokeCap.butt,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isOverBudget
                          ? AppTextConstants.overBudget
                          : AppTextConstants.remaining,
                      style: AppTextStyle.blackS12Medium,
                    ),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBudgetInfoItem(
                '${AppTextConstants.remaining} :',
                FormatUtils.formatCurrency(remaining.abs()),
                isOverBudget: isOverBudget,
                isNegative: isOverBudget,
              ),
              _buildBudgetInfoItem(
                '${AppTextConstants.budget} :',
                FormatUtils.formatCurrency(moneyBudget),
              ),
              _buildBudgetInfoItem(
                '${AppTextConstants.spent} :',
                FormatUtils.formatCurrency(totalSpent),
                isOverBudget: isOverBudget,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetInfoItem(
    String label,
    String value, {
    bool isOverBudget = false,
    bool isNegative = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.blackS12Medium),
        Text(
          isNegative ? '-$value' : value,
          style: AppTextStyle.blackS12.copyWith(
            color: isOverBudget
                ? AppColorConstants.red
                : AppColorConstants.black,
          ),
        ),
      ],
    );
  }
}
