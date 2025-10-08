import 'package:flutter/material.dart';

import '../../../../core/constant/export.dart';
import '../../../../core/text_style/export.dart';
import '../../../../entity/export.dart';
class CalendarGrid extends StatelessWidget {
  final DateTime selectedDate;
  final Map<int, DailyTransactionTotal> dailyTotals;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarGrid({
    super.key,
    required this.selectedDate,
    required this.dailyTotals,
    required this.onDateSelected,
  });

  List<DateTime?> _generateCalendarDays() {
    final firstDay = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDay = DateTime(selectedDate.year, selectedDate.month + 1, 0);

    final List<DateTime?> days = [];

    for (int i = 0; i < firstDay.weekday % 7; i++) {
      days.add(null);
    }

    for (int day = 1; day <= lastDay.day; day++) {
      days.add(DateTime(firstDay.year, firstDay.month, day));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final days = _generateCalendarDays();
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.70,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final date = days[index];
        if (date == null) return const SizedBox();

        final total = dailyTotals[date.day];
        final isSelected = date.day == selectedDate.day &&
            date.month == selectedDate.month &&
            date.year == selectedDate.year;

        return CalendarDayCell(
          date: date,
          total: total,
          isSelected: isSelected,
          onTap: () => onDateSelected(date),
        );
      },
    );
  }
}

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final DailyTransactionTotal? total;
  final bool isSelected;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.date,
    this.total,
    required this.isSelected,
    required this.onTap,
  });

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}tr';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}k';
    }
    return amount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade100 : ColorConstants.greyWhite.withAlpha(60),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: UIConstants.smallSpacing,),
            Text(
              '${date.day}',
              style: AppTextStyle.blackS14,
            ),
            if (total != null && (total!.income > 0 || total!.expense > 0)) ...[
              if (total!.income > 0)
                Text(
                  '+${_formatAmount(total!.income)}',
                  style: AppTextStyle.greenS12,
                  overflow: TextOverflow.ellipsis,
                ),
              if (total!.expense > 0)
                Text(
                  '-${_formatAmount(total!.expense)}',
                  style: AppTextStyle.redS12,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
