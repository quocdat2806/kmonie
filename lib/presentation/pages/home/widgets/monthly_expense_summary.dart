import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/text_style/export.dart';
import '../../../../core/constant/export.dart';
import '../../../../core/navigation/export.dart';
import '../../../../core/util/export.dart';
import '../../../../generated/assets.dart';
import '../../../widgets/export.dart';
import '../../../bloc/export.dart';

class MonthlyExpenseSummary extends StatelessWidget {
  final ValueChanged<DateTime>? onDateChanged;

  const MonthlyExpenseSummary({super.key, this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorConstants.primary,
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        child: Column(
          spacing: UIConstants.defaultSpacing,
          children: <Widget>[_buildHeader(context), _buildSummary()],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildIcon(
          context: context,
          path: Assets.svgsKing,
          routerPath: RouterPath.upgradeVip,
        ),
        Text(
          TextConstants.incomeAndExpenditureBook,
          style: AppTextStyle.blackS18Bold,
        ),
        Row(
          spacing: UIConstants.defaultSpacing,
          children: <Widget>[
            _buildIcon(
              context: context,
              path: Assets.svgsSearch,
              routerPath: RouterPath.searchTransaction,
            ),
            _buildIcon(
              context: context,
              path: Assets.svgsCalendar,
              routerPath: RouterPath.calendarMonthlyTransaction,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIcon({
    required BuildContext context,
    required String path,
    required String routerPath,
  }) {
    return InkWell(
      onTap: () => AppNavigator(context: context).push(routerPath),
      child: SvgPicture.asset(
        path,
        width: UIConstants.mediumIconSize,
        height: UIConstants.mediumIconSize,
      ),
    );
  }

  Widget _buildSummary() {
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
                onTap: () => _onSelectDateTap(context, year, month),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('$year', style: AppTextStyle.blackS14),
                    Row(
                      children: <Widget>[
                        Text(
                          '${TextConstants.month} $month',
                          style: AppTextStyle.blackS14Medium,
                        ),
                        SvgPicture.asset(
                          Assets.svgsArrowDown,
                          width: UIConstants.mediumIconSize,
                          height: UIConstants.mediumIconSize,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _buildSummaryItem(
                TextConstants.expense,
                FormatUtils.formatAmount(data.totalExpense),
              ),
            ),
            Expanded(
              child: _buildSummaryItem(
                TextConstants.income,
                FormatUtils.formatAmount(data.totalIncome),
              ),
            ),
            Expanded(
              child: _buildSummaryItem(
                TextConstants.balance,
                FormatUtils.formatAmount(data.totalBalance),
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

  Future<void> _onSelectDateTap(
    BuildContext context,
    int year,
    int month,
  ) async {
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) =>
          MonthPickerDialog(initialMonth: month, initialYear: year),
    );

    if (result != null && onDateChanged != null) {
      final selectedDate = DateTime(result['year']!, result['month']!);
      onDateChanged?.call(selectedDate);
    }
  }
}
