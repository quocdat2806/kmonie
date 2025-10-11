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
import 'package:kmonie/core/navigation/router_path.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/presentation/widgets/tab_view/app_tab_view.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime(DateTime.now().year, DateTime.now().month);
    return BlocProvider<ReportBloc>(
      create: (_) => ReportBloc(
        sl<BudgetService>(),
        sl<TransactionService>(),
        sl<TransactionCategoryService>(),
      )..add(ReportEvent.init(period: now)),
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
  int _selectedTabIndex = ReportType.analysis.typeIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColorConstants.primary,
        foregroundColor: Colors.white,
        title: Text(AppTextConstants.report, style: AppTextStyle.whiteS18Bold),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          child: Column(
            children: [
              AppTabView<ReportType>(
                types: ReportType.values,
                selectedIndex: _selectedTabIndex,
                getDisplayName: (t) => t.displayName,
                getTypeIndex: (t) => t.typeIndex,
                onTabSelected: (i) => setState(() => _selectedTabIndex = i),
              ),
              const SizedBox(height: AppUIConstants.defaultSpacing),
              Expanded(
                child: BlocBuilder<ReportBloc, ReportState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.message != null) {
                      return Center(
                        child: Text(
                          state.message!,
                          style: AppTextStyle.greyS14,
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMonthHeader(context, state),
                          const SizedBox(height: AppUIConstants.defaultSpacing),
                          if (_selectedTabIndex ==
                              ReportType.analysis.typeIndex)
                            _AnalysisSection(state: state)
                          else
                            _AccountSection(state: state),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthHeader(BuildContext context, ReportState state) {
    final p = state.period ?? DateTime.now();
    final ym = '${AppTextConstants.month} ${p.month}/${p.year}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(ym, style: AppTextStyle.blackS16Bold),
        TextButton(
          onPressed: () async {
            final base = state.period ?? DateTime.now();
            final prev = DateTime(base.year, base.month - 1);
            context.read<ReportBloc>().add(
              ReportEvent.changePeriod(period: prev),
            );
          },
          child: const Text('<'),
        ),
        TextButton(
          onPressed: () async {
            final base = state.period ?? DateTime.now();
            final next = DateTime(base.year, base.month + 1);
            context.read<ReportBloc>().add(
              ReportEvent.changePeriod(period: next),
            );
          },
          child: const Text('>'),
        ),
      ],
    );
  }
}

class _AnalysisSection extends StatelessWidget {
  final ReportState state;
  const _AnalysisSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final entries = state.budgetsByCategory.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ngân sách hàng tháng', style: AppTextStyle.blackS16Bold),
            TextButton(
              onPressed: () async {
                await AppNavigator(context: context).push(RouterPath.budget);
                final s = context.read<ReportBloc>().state;
                final p = s.period ?? DateTime.now();
                context.read<ReportBloc>().add(
                  ReportEvent.changePeriod(period: DateTime(p.year, p.month)),
                );
              },
              child: const Text('Thêm ngân sách'),
            ),
          ],
        ),
        const SizedBox(height: AppUIConstants.smallSpacing),
        for (final e in entries)
          _BudgetItem(
            categoryId: e.key,
            budget: e.value,
            spent: state.spentByCategory[e.key] ?? 0,
            year: (state.period ?? DateTime.now()).year,
            month: (state.period ?? DateTime.now()).month,
          ),
      ],
    );
  }
}

class _AccountSection extends StatelessWidget {
  final ReportState state;
  const _AccountSection({required this.state});

  @override
  Widget build(BuildContext context) {
    // Placeholder for account tab to align with design
    final totalBudget = state.budgetsByCategory.values.fold<int>(
      0,
      (p, c) => p + c,
    );
    final totalSpent = state.spentByCategory.values.fold<int>(
      0,
      (p, c) => p + c,
    );
    final remain = totalBudget - totalSpent;
    final over = remain < 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tổng quan ngân sách', style: AppTextStyle.blackS16Bold),
        const SizedBox(height: AppUIConstants.smallSpacing),
        Text(
          'Tổng ngân sách: $totalBudget',
          style: AppTextStyle.blackS14Medium,
        ),
        Text('Đã chi: $totalSpent', style: AppTextStyle.blackS14Medium),
        Text(
          over ? 'Vượt ngân sách: ${-remain}' : 'Còn lại: $remain',
          style: over ? AppTextStyle.redS14Medium : AppTextStyle.greenS14Medium,
        ),
      ],
    );
  }
}

class _BudgetItem extends StatelessWidget {
  final int categoryId;
  final int budget;
  final int spent;
  final int year;
  final int month;

  const _BudgetItem({
    required this.categoryId,
    required this.budget,
    required this.spent,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final remain = budget - spent;
    final over = remain < 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (over)
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                padding: const EdgeInsets.all(AppUIConstants.smallPadding),
                margin: const EdgeInsets.only(
                  bottom: AppUIConstants.smallSpacing,
                ),
                child: Text(
                  'Đã vượt ngân sách tháng',
                  style: AppTextStyle.whiteS14Bold,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Danh mục #$categoryId', style: AppTextStyle.blackS14Bold),
                Text('Ngân sách: $budget', style: AppTextStyle.blackS14Medium),
              ],
            ),
            const SizedBox(height: AppUIConstants.smallSpacing),
            LinearProgressIndicator(
              value: budget == 0 ? 0 : (spent / budget).clamp(0.0, 1.0),
              backgroundColor: AppColorConstants.grey,
              color: over ? Colors.red : AppColorConstants.primary,
            ),
            const SizedBox(height: AppUIConstants.smallSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Đã chi: $spent', style: AppTextStyle.blackS14Medium),
                Text(
                  over ? 'Vượt: ${-remain}' : 'Còn: $remain',
                  style: over
                      ? AppTextStyle.redS14Medium
                      : AppTextStyle.greenS14Medium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
