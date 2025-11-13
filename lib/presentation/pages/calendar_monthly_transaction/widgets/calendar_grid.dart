import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';

class CalendarGrid extends StatelessWidget {
  final ValueChanged<DateTime> onDateSelected;

  const CalendarGrid({super.key, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      CalendarMonthlyTransactionBloc,
      CalendarMonthTransactionState,
      ({int year, int month})
    >(
      selector: (state) {
        final year = state.currentYear ?? DateTime.now().year;
        final month = state.currentMonth ?? DateTime.now().month;
        return (year: year, month: month);
      },
      builder: (context, monthInfo) {
        final days = AppDateUtils.generateCalendarDays(
          DateTime(monthInfo.year, monthInfo.month),
        );
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.7,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final date = days[index];
            if (date == null) return const SizedBox();
            return CalendarDayCell(
              key: ValueKey('${date.year}-${date.month}-${date.day}'),
              date: date,
              onTap: () => onDateSelected(date),
            );
          },
        );
      },
    );
  }
}

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;

  const CalendarDayCell({super.key, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      CalendarMonthlyTransactionBloc,
      CalendarMonthTransactionState,
      DailyTransactionTotal?
    >(
      selector: (state) => state.dailyTotals[date.day],
      builder: (context, total) {
        return BlocSelector<
          CalendarMonthlyTransactionBloc,
          CalendarMonthTransactionState,
          bool
        >(
          selector: (state) => AppDateUtils.isSameDate(
            date,
            state.selectedDate ?? DateTime.now(),
          ),
          builder: (context, isSelected) {
            return InkWell(
              splashColor: Colors.transparent,
              onTap: onTap,
              child: Container(
                margin: const EdgeInsets.all(
                  AppUIConstants.superExtraSmallSpacing,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColorConstants.green.withAlpha(50)
                      : AppColorConstants.greyWhite.withAlpha(50),
                  borderRadius: BorderRadius.circular(
                    AppUIConstants.smallBorderRadius,
                  ),
                ),
                child: Column(
                  children: [
                     const SizedBox(height: AppUIConstants.smallSpacing),
                    Text('${date.day}', style: AppTextStyle.blackS14),
                    if (total != null &&
                        (total.income > 0 || total.expense > 0)) ...[
                      if (total.income > 0)
                        Text(
                          FormatUtils.formatCurrency(total.income.toInt()),
                          style: AppTextStyle.greenS12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (total.expense > 0)
                        Text(
                          FormatUtils.formatCurrency(total.expense.toInt()),
                          style: AppTextStyle.redS12,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
