import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/services/budget.dart';
import 'package:kmonie/core/services/transaction.dart';
import 'package:kmonie/core/services/transaction_category.dart';
import 'package:kmonie/presentation/bloc/report/report_bloc.dart';
import 'package:kmonie/presentation/bloc/report/report_event.dart';
import 'package:kmonie/presentation/bloc/report/report_state.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/core/utils/utils.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime(DateTime.now().year, DateTime.now().month);
    return BlocProvider<ReportBloc>(
      create: (_) => ReportBloc(sl<BudgetService>(), sl<TransactionService>(), sl<TransactionCategoryService>())..add(ReportEvent.init(period: now)),
      child: const _ReportPageChild(),
    );
  }
}

class _ReportPageChild extends StatefulWidget {
  const _ReportPageChild();

  @override
  State<_ReportPageChild> createState() => _ReportPageChildState();
}

class _ReportPageChildState extends State<_ReportPageChild> {
  void _onTabSelected(int index) {
    context.read<ReportBloc>().add(ReportEvent.changeTab(index: index));
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColorConstants.white,
      child: Column(
        children: [
          ColoredBox(
            color: AppColorConstants.primary,
            child: Column(
              children: [
                const SizedBox(height: AppUIConstants.defaultSpacing),
                Text(AppTextConstants.report, style: AppTextStyle.blackS18Bold),
                const SizedBox(height: AppUIConstants.defaultSpacing),
                BlocBuilder<ReportBloc, ReportState>(
                  buildWhen: (p, c) => p.selectedTabIndex != c.selectedTabIndex,
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.smallPadding),
                      child: AppTabView<ReportType>(types: ExReportType.reportTypes, selectedIndex: state.selectedTabIndex, getDisplayName: (t) => t.displayName, getTypeIndex: (t) => t.typeIndex, onTabSelected: _onTabSelected),
                    );
                  },
                ),
                const SizedBox(height: AppUIConstants.defaultSpacing),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
              child: Column(
                children: [
                  if (context.select((ReportBloc b) => b.state.selectedTabIndex) == ReportType.analysis.typeIndex) ...[_buildMonthlyStatisticsCard(), const SizedBox(height: AppUIConstants.defaultSpacing), _buildMonthlyBudgetCard()] else if (context.select((ReportBloc b) => b.state.selectedTabIndex) == ReportType.account.typeIndex) ...[_buildNetWorthCard(), const SizedBox(height: AppUIConstants.defaultSpacing), _buildAccountActionButtons()],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyStatisticsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Thống kê hàng tháng', style: AppTextStyle.blackS14Bold),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColorConstants.grey),
            ],
          ),
          const SizedBox(height: AppUIConstants.defaultSpacing),
          BlocBuilder<ReportBloc, ReportState>(
            builder: (context, state) {
              final now = DateTime.now();
              final double income = state.totalIncome;
              final double expense = state.totalExpense;
              final double balance = state.totalBalance;

              return Row(
                children: [
                  Text('Thg ${now.month}', style: AppTextStyle.blackS14Medium),
                  _buildStatItem('Chi tiêu', FormatUtils.formatCurrency(expense.toInt())),
                  _buildStatItem('Thu nhập', FormatUtils.formatCurrency(income.toInt())),
                  _buildStatItem('Số dư', FormatUtils.formatCurrency(balance.toInt())),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: AppTextStyle.grayS12Medium),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyle.blackS14Medium),
        ],
      ),
    );
  }

  Widget _buildMonthlyBudgetCard() {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        final monthlyBudget = state.monthlyBudget;
        final totalSpent = state.totalExpense;

        return GestureDetector(
          onTap: () {
            AppNavigator(context: context).push(RouterPath.budget);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ngân sách hàng tháng', style: AppTextStyle.blackS14Bold),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: AppColorConstants.grey),
                  ],
                ),
                const SizedBox(height: AppUIConstants.defaultSpacing),
                MonthlyBudgetSummary(monthlyBudget: monthlyBudget.toInt(), totalSpent: totalSpent.toInt(), useOverBudgetColors: true, alignRight: false),
              ],
            ),
          ),
        );
      },
    );
  }

  // removed duplicate budget info/format helpers (now shared via MonthlyBudgetSummary)

  Widget _buildNetWorthCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
      decoration: BoxDecoration(color: AppColorConstants.primary, borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Giá trị ròng', style: AppTextStyle.blackS14.copyWith(color: AppColorConstants.textGray)),
                    const SizedBox(height: 4),
                    Text('0', style: AppTextStyle.blackS18Bold),
                    const SizedBox(height: 16),
                    Text('Tài sản', style: AppTextStyle.blackS14.copyWith(color: AppColorConstants.textGray)),
                    const SizedBox(height: 4),
                    Text('0', style: AppTextStyle.blackS18Bold),
                  ],
                ),
              ),
              Column(
                children: [
                  const Icon(Icons.account_balance_wallet, size: 48, color: AppColorConstants.textGray),
                  const SizedBox(height: 16),
                  Text('Nợ phải trả', style: AppTextStyle.blackS14.copyWith(color: AppColorConstants.textGray)),
                  const SizedBox(height: 4),
                  Text('0', style: AppTextStyle.blackS18Bold),
                ],
              ),
            ],
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
            text: 'Thêm tài khoản',
            onTap: () {
              AppNavigator(context: context).push(RouterPath.addAccount);
            },
          ),
        ),
        const SizedBox(width: AppUIConstants.defaultSpacing),
        Expanded(
          child: _buildActionButton(
            text: 'Quản lý tài khoản',
            onTap: () {
              // TODO: Navigate to manage account page
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppUIConstants.defaultSpacing, horizontal: AppUIConstants.defaultPadding),
        decoration: BoxDecoration(
          color: AppColorConstants.white,
          borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Center(child: Text(text, style: AppTextStyle.blackS14Medium)),
      ),
    );
  }
}
