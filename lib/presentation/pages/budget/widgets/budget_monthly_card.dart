import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class BudgetMonthlyCard extends StatelessWidget {
  const BudgetMonthlyCard({super.key, required this.monthlyBudget, required this.totalSpent});

  final int monthlyBudget;
  final int totalSpent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ngân sách hàng tháng', style: AppTextStyle.blackS16Bold),
              TextButton(
                onPressed: () {},
                child: Text('Sửa', style: AppTextStyle.blueS14Medium),
              ),
            ],
          ),
          const SizedBox(height: AppUIConstants.defaultSpacing),
          BudgetProcessIndicator(moneyBudget: monthlyBudget, totalSpent: totalSpent),
        ],
      ),
    );
  }
}
