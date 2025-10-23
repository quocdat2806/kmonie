import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/presentation/bloc/home/home.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class MonthlyExpenseSummary extends StatelessWidget {
  final ValueChanged<DateTime>? onDateChanged;

  const MonthlyExpenseSummary({super.key, this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColorConstants.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        child: Column(spacing: AppUIConstants.defaultSpacing, children: <Widget>[_buildHeader(context), _buildSummary()]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(AppTextConstants.incomeAndExpenditureBook, style: AppTextStyle.blackS18Bold),
        Row(
          spacing: AppUIConstants.defaultSpacing,
          children: <Widget>[
            _buildIcon(context: context, path: Assets.svgsSearch, routerPath: RouterPath.searchTransaction),
            _buildIcon(context: context, path: Assets.svgsCalendar, routerPath: RouterPath.calendarMonthlyTransaction),
          ],
        ),
      ],
    );
  }

  Widget _buildIcon({required BuildContext context, required String path, required String routerPath}) {
    return InkWell(
      onTap: () => AppNavigator(context: context).push(routerPath),
      child: SvgUtils.icon(assetPath: path, size: SvgSizeType.medium),
    );
  }

  Widget _buildSummary() {
    return BlocSelector<HomeBloc, HomeState, ({DateTime? selectedDate, double totalExpense, double totalIncome, double totalBalance})>(
      selector: (state) => (selectedDate: state.selectedDate, totalExpense: state.totalExpense, totalIncome: state.totalIncome, totalBalance: state.totalBalance),
      builder: (context, data) {
        final selectedDate = data.selectedDate ?? DateTime.now();
        final year = selectedDate.year;
        final month = selectedDate.month;

        return Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () => _onSelectDateTap(context, year, month),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('$year', style: AppTextStyle.blackS14),
                    Row(
                      children: <Widget>[
                        Text('${AppTextConstants.month} $month', style: AppTextStyle.blackS14),
                        SvgUtils.icon(assetPath: Assets.svgsArrowDown, size: SvgSizeType.medium),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: _buildSummaryItem(AppTextConstants.expense, FormatUtils.formatCurrency(data.totalExpense.toInt()))),
            Expanded(child: _buildSummaryItem(AppTextConstants.income, FormatUtils.formatCurrency(data.totalIncome.toInt()))),
            Expanded(child: _buildSummaryItem(AppTextConstants.balance, FormatUtils.formatCurrency(data.totalBalance.toInt()))),
          ],
        );
      },
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: <Widget>[
        Text(label, style: AppTextStyle.blackS14),
        Text(
          value,
          maxLines: AppUIConstants.singleLine,
          style: AppTextStyle.blackS14.copyWith(overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Future<void> _onSelectDateTap(BuildContext context, int year, int month) async {
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) => MonthPickerDialog(initialMonth: month, initialYear: year),
    );

    if (result != null && onDateChanged != null) {
      final selectedDate = DateTime(result['year']!, result['month']!);
      onDateChanged?.call(selectedDate);
    }
  }
}
