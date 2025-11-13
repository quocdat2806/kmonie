import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class MonthlyStatisticsPage extends StatelessWidget {
  const MonthlyStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MonthlyStatisticsPageChild();
  }
}

class MonthlyStatisticsPageChild extends StatefulWidget {
  const MonthlyStatisticsPageChild({super.key});

  @override
  State<MonthlyStatisticsPageChild> createState() =>
      _MonthlyStatisticsPageChildState();
}

class _MonthlyStatisticsPageChildState
    extends State<MonthlyStatisticsPageChild> {
  final _dropdownKey = GlobalKey();

  String _getSelectedText(int? selectedYear) {
    if (selectedYear == null) return AppTextConstants.all;
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
                margin: const EdgeInsets.only(
                  right: AppUIConstants.smallSpacing,
                ),
                child: GestureDetector(
                  key: _dropdownKey,
                  onTap: () {
                    if (state.availableYears.isEmpty) return;
                    AppDropdown.show<int?>(
                      context: context,
                      targetKey: _dropdownKey,
                      items: <int?>[null, ...state.availableYears],
                      itemBuilder: (year) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppUIConstants.defaultPadding,
                          vertical: AppUIConstants.smallSpacing,
                        ),
                        child: Text(
                          year == null ? AppTextConstants.all : year.toString(),
                          style: AppTextStyle.blackS14Medium,
                        ),
                      ),
                      onItemSelected: (year) {
                        context.read<MonthlyStatisticsBloc>().add(
                          MonthlyStatisticsEvent.load(year: year),
                        );
                      },
                    );
                  },
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getSelectedText(state.selectedYear),
                          style: AppTextStyle.blackS14Medium,
                        ),
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
          if (state.loadStatus==LoadStatus.loading) {
            return const SizedBox();
          }

          return ColoredBox(
            color: AppColorConstants.white,
            child: Column(
              children: [
                Container(
                  color: AppColorConstants.primary,
                  padding: const EdgeInsets.only(
                    bottom: AppUIConstants.defaultPadding,
                  ),
                  child: SpendingSummarySection(
                    expense: state.totalExpense.toInt(),
                    income: state.totalIncome.toInt(),
                    balance: state.totalBalance.toInt(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppUIConstants.defaultPadding,
                    vertical: AppUIConstants.smallPadding,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: AppColorConstants.greyWhite),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildRow(label: AppTextConstants.month),
                      _buildRow(label: AppTextConstants.expense),
                      _buildRow(label: AppTextConstants.income),
                      _buildRow(label: AppTextConstants.accountBalanceLabel),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppUIConstants.defaultPadding,
                              vertical: AppUIConstants.smallPadding,
                            ),
                            child: Text(
                              year.toString(),
                              style: AppTextStyle.blackS14Medium,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: yearMonths.length,
                            itemBuilder: (_, monthIndex) {
                              final m = yearMonths[monthIndex];
                              return Container(
                                padding: const EdgeInsets.all(
                                  AppUIConstants.defaultPadding,
                                ),
                                child: Row(
                                  children: [
                                    _buildRow(label: 'Tháng ${m.month}'),
                                    _buildRow(
                                      label: FormatUtils.formatCurrency(
                                        m.expense.toInt(),
                                      ),
                                    ),
                                    _buildRow(
                                      label: FormatUtils.formatCurrency(
                                        m.income.toInt(),
                                      ),
                                    ),
                                    _buildRow(
                                      label: FormatUtils.formatCurrency(
                                        (m.income - m.expense).toInt(),
                                      ),
                                    ),
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

  Widget _buildRow({required String label}) {
    return Expanded(child: Text(label, style: AppTextStyle.blackS14Medium));
  }
}
