import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/cache/export.dart';
import '../../../../core/text_style/export.dart';
import '../../../../core/constant/exports.dart';
import '../../../../core/navigation/exports.dart';

import '../../../../generated/assets.dart';
import '../../../widgets/exports.dart';
import '../../../bloc/exports.dart';

class MonthlyExpenseSummary extends StatefulWidget {
  final ValueChanged<DateTime>? onDateChanged;

  const MonthlyExpenseSummary({super.key, this.onDateChanged});

  @override
  State<MonthlyExpenseSummary> createState() => _MonthlyExpenseSummaryState();
}

class _MonthlyExpenseSummaryState extends State<MonthlyExpenseSummary> {

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorConstants.primary,
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            const SizedBox(height: UIConstants.defaultSpacing),
            _buildSummaryRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            AppNavigator(context: context).push(RouterPath.upgradeVip);
          },
          child: SvgCacheManager().getSvg(
            Assets.svgsKing,
            UIConstants.mediumIconSize,
            UIConstants.mediumIconSize,
          ),
        ),
        Text('Sổ Thu Chi', style: AppTextStyle.blackS18Bold),
        Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                AppNavigator(context: context).push(RouterPath.searchTransaction);
              },
              child: SvgCacheManager().getSvg(
                Assets.svgsSearch,
                UIConstants.mediumIconSize,
                UIConstants.mediumIconSize,
              ),
            ),
            const SizedBox(width: UIConstants.defaultSpacing),
            InkWell(
              onTap: () {
                AppNavigator(context: context).push(RouterPath.calendarMonthlyTransaction);
              },
              child: SvgCacheManager().getSvg(
                Assets.svgsCalendar,
                UIConstants.mediumIconSize,
                UIConstants.mediumIconSize,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow() {
    return BlocSelector<
      HomeBloc,
      HomeState,
      ({
        DateTime? selectedDate,
        double totalExpense,
        double totalIncome,
        double totalBalance,
      })
    >(
      selector: (state) => (
        selectedDate: state.selectedDate,
        totalExpense: state.totalExpense,
        totalIncome: state.totalIncome,
        totalBalance: state.totalBalance,
      ),
      builder: (context, data) {
        final selectedDate = data.selectedDate ?? DateTime.now();
        final year = selectedDate.year;
        final month = selectedDate.month;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () async {
                  final result = await showDialog<Map<String, int>>(
                    context: context,
                    builder: (context) => MonthPickerDialog(
                      initialMonth: month,
                      initialYear: year,
                    ),
                  );
                  if (result != null && widget.onDateChanged != null) {
                    final selectedDate = DateTime(
                      result['year']!,
                      result['month']!,
                    );
                    widget.onDateChanged!(selectedDate);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('$year', style: AppTextStyle.blackS14),
                    Row(
                      children: <Widget>[
                        Text('Thg $month', style: AppTextStyle.blackS14Medium),
                        SvgCacheManager().getSvg(
                          Assets.svgsArrowDown,
                          UIConstants.mediumIconSize,
                          UIConstants.mediumIconSize,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _buildSummaryItem(
                'Chi tiêu',
                _formatAmount(data.totalExpense),
              ),
            ),
            Expanded(
              child: _buildSummaryItem(
                'Thu nhập',
                _formatAmount(data.totalIncome),
              ),
            ),
            Expanded(
              child: _buildSummaryItem(
                'Số dư',
                _formatAmount(data.totalBalance),
              ),
            ),
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
          maxLines: UIConstants.singleLine,
          style: AppTextStyle.blackS14Medium.copyWith(
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount == 0) return '0';
    final formatter = NumberFormat('#,###');
    return formatter.format(amount.toInt());
  }
}
