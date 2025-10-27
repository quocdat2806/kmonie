import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class MonthlyStatisticsCard extends StatelessWidget {
  const MonthlyStatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppNavigator(context: context).push(RouterPath.monthlyStatistics),
      child: Container(
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        decoration: BoxDecoration(
          color: AppColorConstants.white,
          borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.4), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          spacing: AppUIConstants.defaultSpacing,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppTextConstants.monthlyStatistics, style: AppTextStyle.blackS14Bold),
                const Icon(Icons.arrow_forward_ios, size: AppUIConstants.smallIconSize, color: AppColorConstants.black),
              ],
            ),
            BlocBuilder<ReportBloc, ReportState>(
              buildWhen: (previous, current) => previous.totalIncome != current.totalIncome || previous.totalExpense != current.totalExpense || previous.totalBalance != current.totalBalance,
              builder: (context, state) {
                final now = DateTime.now();
                return MonthlySummaryItem(year: now.year, month: now.month, expense: state.totalExpense.toInt(), income: state.totalIncome.toInt(), balance: state.totalBalance.toInt());
              },
            ),
          ],
        ),
      ),
    );
  }
}
