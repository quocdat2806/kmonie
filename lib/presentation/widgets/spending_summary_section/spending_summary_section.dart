import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';

class SpendingSummarySection extends StatelessWidget {
  final int year;
  final int month;
  final int expense;
  final int income;
  final int balance;
  final VoidCallback? onTap;
  final Widget? suffix;

  const SpendingSummarySection({super.key, required this.year, required this.month, required this.expense, required this.income, required this.balance, this.onTap, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$year', style: AppTextStyle.blackS14),
                Row(
                  children: [
                    Text('Thg $month', style: AppTextStyle.blackS14),
                    if (suffix != null) suffix!,
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _buildSummaryItem(AppTextConstants.expense, FormatUtils.formatCurrency(expense))),
        Expanded(child: _buildSummaryItem(AppTextConstants.income, FormatUtils.formatCurrency(income))),
        Expanded(child: _buildSummaryItem(AppTextConstants.balance, FormatUtils.formatCurrency(balance))),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyle.blackS14),
        Text(
          value,
          maxLines: AppUIConstants.singleLine,
          style: AppTextStyle.blackS14.copyWith(overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
