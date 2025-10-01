import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmonie/presentation/pages/calendar_monthly_transaction/test.dart';

import '../../widgets/appBar/app_bar.dart';

class CalendarMonthlyTransaction extends StatefulWidget {
  const CalendarMonthlyTransaction({super.key});

  @override
  State<CalendarMonthlyTransaction> createState() => _CalendarMonthlyTransactionState();
}

class _CalendarMonthlyTransactionState extends State<CalendarMonthlyTransaction> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  // mock data
  Map<int, Map<String, int>> dataByDay = {
    13: {'income': 40000, 'expense': 0},
    15: {'income': 11300000, 'expense': 0},
    20: {'income': 50000, 'expense': 3000},
  };

  @override
  Widget build(BuildContext context) {
    return CalendarScreen();
    // final firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);
    // final daysInMonth = DateUtils.getDaysInMonth(selectedYear, selectedMonth);
    // final int startWeekday = firstDayOfMonth.weekday % 7; // Make Sunday = 0
    // return Scaffold(
    //   appBar: const CustomAppBar(title: 'Lịch',actions: [
    //
    //   ],),
    //   floatingActionButton: FloatingActionButton(
    //     backgroundColor: Colors.yellow[700],
    //     onPressed: () {
    //     },
    //     child: const Icon(Icons.add, color: Colors.black),
    //   ),
    //   body: Column(
    //     children: [
    //       _buildWeekdaysHeader(),
    //       const SizedBox(height: 8),
    //       Expanded(child: _buildCalendarGrid(startWeekday, daysInMonth)),
    //     ],
    //   ),
    // );
  }

  Widget _buildWeekdaysHeader() {
    const days = ['CN', 'Th 2', 'Th 3', 'Th 4', 'Th 5', 'Th 6', 'Th 7'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map((d) => Expanded(child: Center(child: Text(d))))
          .toList(),
    );
  }

  Widget _buildCalendarGrid(int startWeekday, int daysInMonth) {
    final totalSlots = startWeekday + daysInMonth;
    return GridView.builder(
      itemCount: totalSlots,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        if (index < startWeekday) return const SizedBox.shrink(); // empty slot

        final day = index - startWeekday + 1;
        final data = dataByDay[day];

        final isHighlighted = data != null;
        return Container(
          decoration: BoxDecoration(
            color: isHighlighted ? Colors.green.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$day'),
              if (data != null && data['income']! > 0)
                Text(
                  NumberFormat.decimalPattern().format(data['income']),
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
              if (data != null && data['expense']! > 0)
                Text(
                  NumberFormat.decimalPattern().format(data['expense']),
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ),
        );
      },
    );
  }

  void _pickMonth() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime(selectedYear, selectedMonth),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
      locale: const Locale('vi', 'VN'),
    );

    if (result != null) {
      setState(() {
        selectedMonth = result.month;
        selectedYear = result.year;
      });
    }
  }
}
