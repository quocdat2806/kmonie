import 'package:flutter/material.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime selectedDate;
  final Map<int, DailyTransactionTotal> dailyTotals;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarGrid({super.key, required this.selectedDate, required this.dailyTotals, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    final days = AppDateUtils.generateCalendarDays(selectedDate);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 0.70),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final date = days[index];
        if (date == null) return const SizedBox();
        final total = dailyTotals[date.day];
        final isSelected = AppDateUtils.isSameDate(date, selectedDate);

        return CalendarDayCell(date: date, total: total, isSelected: isSelected, onTap: () => onDateSelected(date));
      },
    );
  }
}

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final DailyTransactionTotal? total;
  final bool isSelected;
  final VoidCallback onTap;

  const CalendarDayCell({super.key, required this.date, this.total, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(AppUIConstants.extraSmallSpacingMin),
        decoration: BoxDecoration(color: isSelected ? AppColorConstants.green.withAlpha(60) : AppColorConstants.greyWhite.withAlpha(60), borderRadius: BorderRadius.circular(AppUIConstants.smallBorderRadius)),
        child: Column(
          children: [
            const SizedBox(height: AppUIConstants.smallSpacing),
            Text('${date.day}', style: AppTextStyle.blackS14),
            if (total != null && (total!.income > 0 || total!.expense > 0)) ...[if (total!.income > 0) Text(FormatUtils.formatCurrency(total!.income.toInt()), style: AppTextStyle.greenS12, overflow: TextOverflow.ellipsis), if (total!.expense > 0) Text(FormatUtils.formatCurrency(total!.expense.toInt()), style: AppTextStyle.redS12, overflow: TextOverflow.ellipsis)],
          ],
        ),
      ),
    );
  }
}
