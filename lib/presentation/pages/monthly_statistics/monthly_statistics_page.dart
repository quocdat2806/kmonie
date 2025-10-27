import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/generated/generated.dart';

class MonthlyStatisticsPage extends StatelessWidget {
  const MonthlyStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => MonthlyStatisticsBloc()..add(const MonthlyStatisticsEvent.load()), child: const _MonthlyStatisticsView());
  }
}

class _MonthlyStatisticsView extends StatefulWidget {
  const _MonthlyStatisticsView();

  @override
  State<_MonthlyStatisticsView> createState() => _MonthlyStatisticsViewState();
}

class _MonthlyStatisticsViewState extends State<_MonthlyStatisticsView> {
  final _dropdownKey = GlobalKey();

  String _getSelectedText(int? selectedYear) {
    if (selectedYear == null) return 'Tất cả';
    return selectedYear.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        actions: [
          BlocBuilder<MonthlyStatisticsBloc, MonthlyStatisticsState>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.only(right: AppUIConstants.smallSpacing),
                child: GestureDetector(
                  key: _dropdownKey,
                  onTap: () {
                    if (state.availableYears.isEmpty) return;
                    AppDropdown.show<int?>(
                      context: context,
                      targetKey: _dropdownKey,
                      items: <int?>[null, ...state.availableYears],
                      itemBuilder: (year) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.defaultPadding, vertical: AppUIConstants.smallSpacing),
                        child: Text(year == null ? 'Tất cả' : year.toString(), style: AppTextStyle.blackS14Medium),
                      ),
                      onItemSelected: (year) {
                        context.read<MonthlyStatisticsBloc>().add(MonthlyStatisticsEvent.load(year: year));
                      },
                    );
                  },
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_getSelectedText(state.selectedYear), style: AppTextStyle.blackS14Medium),
                        const SizedBox(width: 4),
                        SvgUtils.icon(assetPath: Assets.svgsArrowDown),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MonthlyStatisticsBloc, MonthlyStatisticsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const SizedBox();
          }

          return ColoredBox(
            color: AppColorConstants.white,
            child: Column(
              children: [
                Container(
                  color: AppColorConstants.primary,
                  padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('Thu nhập', style: AppTextStyle.blackS16Bold),
                            Text(FormatUtils.formatCurrency(state.totalIncome.toInt()), style: AppTextStyle.blackS14Medium),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Chi tiêu', style: AppTextStyle.blackS16Bold),
                            Text(FormatUtils.formatCurrency(state.totalExpense.toInt()), style: AppTextStyle.blackS14Medium),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Số dư', style: AppTextStyle.blackS16Bold),
                            Text(FormatUtils.formatCurrency((state.totalIncome - state.totalExpense).toInt()), style: AppTextStyle.blackS14Medium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.defaultPadding, vertical: AppUIConstants.smallSpacing),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: AppColorConstants.greyWhite)),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text('Tháng', style: AppTextStyle.blackS14Medium)),
                      Expanded(child: Text('Chi', style: AppTextStyle.blackS14Medium)),
                      Expanded(child: Text('Thu', style: AppTextStyle.blackS14Medium)),
                      Expanded(child: Text('Số dư', style: AppTextStyle.blackS14Medium)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.monthsByYear.keys.length,
                    itemBuilder: (_, yearIndex) {
                      final year = state.monthsByYear.keys.toList()[yearIndex];
                      final yearMonths = state.monthsByYear[year]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.defaultPadding, vertical: 8),
                            child: Text(year.toString(), style: AppTextStyle.blackS14Medium),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: yearMonths.length,
                            itemBuilder: (_, monthIndex) {
                              final m = yearMonths[monthIndex];
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.defaultPadding, vertical: AppUIConstants.defaultSpacing),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('Tháng ${m.month}', style: AppTextStyle.blackS14Medium)),
                                    Expanded(child: Text(FormatUtils.formatCurrency(m.expense.toInt()), style: AppTextStyle.blackS14Medium)),
                                    Expanded(child: Text(FormatUtils.formatCurrency(m.income.toInt()), style: AppTextStyle.blackS14Medium)),
                                    Expanded(child: Text(FormatUtils.formatCurrency((m.income - m.expense).toInt()), style: AppTextStyle.blackS14Medium)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
