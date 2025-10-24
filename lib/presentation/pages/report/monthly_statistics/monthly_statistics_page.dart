import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/blocs/monthly_statistics/monthly_statistics.dart';

class MonthlyStatisticsPage extends StatelessWidget {
  const MonthlyStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => MonthlyStatisticsBloc()..add(const MonthlyStatisticsEvent.load()), child: const _MonthlyStatisticsView());
  }
}

class _MonthlyStatisticsView extends StatelessWidget {
  const _MonthlyStatisticsView();

  @override
  Widget build(BuildContext context) {
    const title = 'Tổng số dư';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColorConstants.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(title, style: AppTextStyle.blackS16Bold),
        actions: [
          TextButton(
            onPressed: () async {
              final now = DateTime.now();
              final years = List<int>.generate(10, (i) => now.year - i);
              final int? chosen = await showModalBottomSheet<int>(
                context: context,
                builder: (_) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(title: const Text('Tất cả'), onTap: () => Navigator.of(context).pop()),
                      for (final y in years) ListTile(title: Text('Năm $y'), onTap: () => Navigator.of(context).pop(y)),
                    ],
                  ),
                ),
              );
              if (context.mounted) {
                context.read<MonthlyStatisticsBloc>().add(MonthlyStatisticsEvent.load(year: chosen));
              }
            },
            child: BlocBuilder<MonthlyStatisticsBloc, MonthlyStatisticsState>(
              builder: (context, state) => Row(
                children: [
                  Text(state.selectedYear == null ? 'Tất cả' : 'Năm ${state.selectedYear!}', style: AppTextStyle.blackS14Medium),
                  const Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<MonthlyStatisticsBloc, MonthlyStatisticsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final months = state.months;
          double income = 0, expense = 0;
          for (final m in months) {
            income += m.income;
            expense += m.expense;
          }
          return Column(
            children: [
              Container(
                width: double.infinity,
                color: AppColorConstants.primary,
                padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
                child: Column(
                  children: [
                    Text(title, style: AppTextStyle.blackS14),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Chi tiêu : ${FormatUtils.formatCurrency(expense.toInt())}', style: AppTextStyle.blackS14Medium),
                        Text('Thu nhập : ${FormatUtils.formatCurrency(income.toInt())}', style: AppTextStyle.blackS14Medium),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: months.length,
                  itemBuilder: (_, i) {
                    final m = months[i];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.defaultPadding, vertical: AppUIConstants.defaultSpacing),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          Expanded(child: Text('Thg ${m.month}', style: AppTextStyle.blackS14Medium)),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(FormatUtils.formatCurrency(m.expense.toInt()), style: AppTextStyle.blackS14Medium),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(FormatUtils.formatCurrency(m.income.toInt()), style: AppTextStyle.blackS14Medium),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(FormatUtils.formatCurrency((m.income - m.expense).toInt()), style: AppTextStyle.blackS14Medium),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
