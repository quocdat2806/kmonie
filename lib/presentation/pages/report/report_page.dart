import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

import 'widgets/monthly_statistics_report.dart';
import 'widgets/net_worth_card.dart';
import 'widgets/report_tab_bar.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReportPageChild();
  }
}

class ReportPageChild extends StatefulWidget {
  const ReportPageChild({super.key});

  @override
  State<ReportPageChild> createState() => _ReportPageChildState();
}

class _ReportPageChildState extends State<ReportPageChild> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColorConstants.white,
      child: Column(
        children: [
          ColoredBox(
            color: AppColorConstants.primary,
            child: Padding(
              padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
              child: Column(
                spacing: AppUIConstants.defaultSpacing,
                children: [
                  Text(
                    AppTextConstants.report,
                    style: AppTextStyle.blackS18Bold,
                  ),
                  const ReportTabBar(),
                ],
              ),
            ),
          ),
          BlocBuilder<ReportBloc, ReportState>(
            buildWhen: (prev, current) =>
                prev.selectedTabIndex != current.selectedTabIndex ||
                prev.monthlyBudget != current.monthlyBudget ||
                prev.totalExpense != current.totalExpense ||
                prev.accounts != current.accounts,
            builder: (context, state) {
              if (state.selectedTabIndex == ReportType.account.typeIndex) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      AppUIConstants.defaultPadding,
                    ),
                    child: Column(
                      children: [
                        const NetWorthCard(),
                        _buildAccountActionButtons(),
                        Expanded(child: AccountsList(accounts: state.accounts)),
                      ],
                    ),
                  ),
                );
              }
              final monthlyBudget = state.monthlyBudget;
              final totalSpent = state.totalExpense;
              return Padding(
                padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
                child: Column(
                  spacing: AppUIConstants.defaultSpacing,
                  children: [
                    const MonthlyStatisticsReport(),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        AppNavigator(context: context).push(RouterPath.budget);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(
                          AppUIConstants.defaultPadding,
                        ),
                        decoration: AppUIConstants.defaultShadow(),
                        child: Column(
                          spacing: AppUIConstants.defaultSpacing,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppTextConstants.monthlyBudget,
                                  style: AppTextStyle.blackS14Bold,
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: AppUIConstants.smallIconSize,
                                  color: AppColorConstants.grey,
                                ),
                              ],
                            ),
                            BudgetMonthlySection(
                              moneyBudget: monthlyBudget.toInt(),
                              totalSpent: totalSpent.toInt(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            text: AppTextConstants.addAccount,
            onTap: () {
              AppNavigator(context: context).push(RouterPath.addAccount);
            },
          ),
        ),
        const SizedBox(width: AppUIConstants.defaultSpacing),
        Expanded(
          child: _buildActionButton(
            text: AppTextConstants.manageAccount,
            onTap: () {
              AppNavigator(context: context).push(RouterPath.manageAccount);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return AppButton(
      text: text,
      onPressed: onTap,
      backgroundColor: Colors.transparent,
    );
  }
}
