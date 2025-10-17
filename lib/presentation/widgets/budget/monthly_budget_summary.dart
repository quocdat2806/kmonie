import 'package:flutter/material.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';

class MonthlyBudgetSummary extends StatelessWidget {
  const MonthlyBudgetSummary({
    super.key,
    required this.monthlyBudget,
    required this.totalSpent,
    this.useOverBudgetColors = false,
    this.alignRight = true,
  });

  final int monthlyBudget;
  final int totalSpent;
  final bool
  useOverBudgetColors; // when true, show red background when over budget (as in report)
  final bool
  alignRight; // controls info alignment (right in budget page, left in report)

  @override
  Widget build(BuildContext context) {
    final int remaining = monthlyBudget - totalSpent;
    final double progress = monthlyBudget > 0
        ? (totalSpent / monthlyBudget).clamp(0.0, 1.0)
        : 0.0;
    final bool isOverBudget =
        remaining < 0 ||
        (useOverBudgetColors && totalSpent > 0 && monthlyBudget == 0);

    return Row(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            children: [
              Transform.rotate(
                angle: 0,
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: isOverBudget && useOverBudgetColors
                        ? Colors.red
                        : AppColorConstants.primary,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOverBudget && useOverBudgetColors
                          ? Colors.red.shade700
                          : Colors.grey,
                    ),
                    strokeCap: StrokeCap.butt,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isOverBudget ? 'Vượt quá' : 'Còn lại',
                      style: AppTextStyle.blackS12Medium,
                    ),
                    Text(
                      isOverBudget && useOverBudgetColors
                          ? '100.0%'
                          : '${(isOverBudget ? (progress * 100) : (100 - progress * 100)).toStringAsFixed(1)}%',
                      style: AppTextStyle.blackS12Medium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppUIConstants.defaultSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: alignRight
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              _buildBudgetInfoItem(
                'Còn lại :',
                FormatUtils.formatCurrency(remaining.abs()),
                isOverBudget: remaining < 0,
                isNegative: remaining < 0,
              ),
              const SizedBox(height: 6),
              _buildBudgetInfoItem(
                'Ngân sách :',
                FormatUtils.formatCurrency(monthlyBudget),
              ),
              const SizedBox(height: 6),
              _buildBudgetInfoItem(
                'Chi tiêu :',
                FormatUtils.formatCurrency(totalSpent),
                isOverBudget: remaining < 0,
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

  // String _formatAmount(int amount) {
  //   if (amount == 0) return '0';
  //   return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  // }
}
