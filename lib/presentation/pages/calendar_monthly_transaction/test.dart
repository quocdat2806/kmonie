// models/transaction.dart
import 'package:flutter/material.dart';
import 'package:kmonie/core/constant/color.dart';
class Transaction {
  final double income;
  final double expense;

  const Transaction({
    this.income = 0,
    this.expense = 0,
  });

  bool get hasData => income > 0 || expense > 0;
}

// models/calendar_data.dart
class CalendarData {
  final DateTime selectedDate;
  final Map<int, Transaction> transactions;

  const CalendarData({
    required this.selectedDate,
    required this.transactions,
  });

  static CalendarData get sample => CalendarData(
    selectedDate: DateTime(2025, 9, 20),
    transactions: {
      2: const Transaction(income: 90000),
      13: const Transaction(income: 40000),
      15: const Transaction(income: 11300),
      20: const Transaction(income: 500000000, expense: 3000),
      29: const Transaction(income: 6666),
    },
  );
}

// screens/calendar_screen.dart
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarData _calendarData;

  @override
  void initState() {
    super.initState();
    _calendarData = CalendarData.sample;
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _calendarData = CalendarData(
        selectedDate: date,
        transactions: _calendarData.transactions,
      );
    });
  }

  void _onMonthChanged(DateTime date) {
    setState(() {
      _calendarData = CalendarData(
        selectedDate: date,
        transactions: _calendarData.transactions,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CalendarAppBar(
        selectedDate: _calendarData.selectedDate,
        onMonthChanged: _onMonthChanged,
      ),
      body: CalendarView(
        calendarData: _calendarData,
        onDateSelected: _onDateSelected,
      ),
      floatingActionButton: const AddTransactionButton(),
    );
  }
}

// widgets/calendar_app_bar.dart
class CalendarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onMonthChanged;

  const CalendarAppBar({
    super.key,
    required this.selectedDate,
    required this.onMonthChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  String _getMonthYearText() {
    const months = [
      '',
      'thg 1',
      'thg 2',
      'thg 3',
      'thg 4',
      'thg 5',
      'thg 6',
      'thg 7',
      'thg 8',
      'thg 9',
      'thg 10',
      'thg 11',
      'thg 12'
    ];
    return '${months[selectedDate.month]} ${selectedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.amber.shade400,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () {},
      ),
      title: const Text(
        'Lịch',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {
              // Show month picker
            },
            child: Row(
              children: [
                Text(
                  _getMonthYearText(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// widgets/calendar_view.dart
class CalendarView extends StatelessWidget {
  final CalendarData calendarData;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarView({
    super.key,
    required this.calendarData,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WeekdayHeader(),
        Expanded(
          child: CalendarGrid(
            calendarData: calendarData,
            onDateSelected: onDateSelected,
          ),
        ),
      ],
    );
  }
}

// widgets/weekday_header.dart
class WeekdayHeader extends StatelessWidget {
  const WeekdayHeader({super.key});

  static const _weekdays = ['CN', 'Th 2', 'Th 3', 'Th 4', 'Th 5', 'Th 6', 'Th 7'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: _weekdays
            .map((day) => Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ))
            .toList(),
      ),
    );
  }
}

// widgets/calendar_grid.dart
class CalendarGrid extends StatelessWidget {
  final CalendarData calendarData;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarGrid({
    super.key,
    required this.calendarData,
    required this.onDateSelected,
  });

  List<DateTime?> _generateCalendarDays() {
    final firstDay = DateTime(
      calendarData.selectedDate.year,
      calendarData.selectedDate.month,
      1,
    );
    final lastDay = DateTime(
      calendarData.selectedDate.year,
      calendarData.selectedDate.month + 1,
      0,
    );

    final List<DateTime?> days = [];

    // Add empty cells for days before first day of month
    for (int i = 0; i < firstDay.weekday % 7; i++) {
      days.add(null);
    }

    // Add all days of the month
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
        childAspectRatio: 0.75,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final date = days[index];
        if (date == null) return const SizedBox();
        final transaction = calendarData.transactions[date.day];
        final isSelected = date.day == calendarData.selectedDate.day &&
            date.month == calendarData.selectedDate.month &&
            date.year == calendarData.selectedDate.year;
        return CalendarDayCell(
          date: date,
          transaction: transaction,
          isSelected: isSelected,
          onTap: () => onDateSelected(date),
        );
      },
    );
  }
}

// widgets/calendar_day_cell.dart
class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final Transaction? transaction;
  final bool isSelected;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.date,
    this.transaction,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade100 : ColorConstants.iconBackground,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            if (transaction?.hasData ?? false) ...[
              const SizedBox(height: 4),
              if (transaction!.income > 0)
                TransactionText(
                  amount: transaction!.income,
                  isIncome: true,
                ),
              if (transaction!.expense > 0)
                TransactionText(
                  amount: transaction!.expense,
                  isIncome: false,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

// widgets/transaction_text.dart
class TransactionText extends StatelessWidget {
  final double amount;
  final bool isIncome;

  const TransactionText({
    super.key,
    required this.amount,
    required this.isIncome,
  });

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      final formatted = (amount / 1000).toStringAsFixed(3);
      return formatted.endsWith('000')
          ? formatted.substring(0, formatted.length - 4)
          : formatted.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return amount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        '${(amount)}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          color: isIncome ? Colors.green.shade600 : Colors.red.shade600,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// widgets/add_transaction_button.dart
class AddTransactionButton extends StatelessWidget {
  const AddTransactionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.amber.shade400,
      onPressed: () {
        // Handle add transaction
      },
      child: const Icon(
        Icons.add,
        color: Colors.black87,
        size: 32,
      ),
    );
  }
}