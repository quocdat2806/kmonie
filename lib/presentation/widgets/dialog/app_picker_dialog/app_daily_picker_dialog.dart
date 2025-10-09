import 'package:flutter/material.dart';
import '../../../../core/constant/export.dart';

class DatePickerScreen extends StatefulWidget {
  final DateTime? initialDate;

  const DatePickerScreen({Key? key,this.initialDate}) : super(key: key);

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
 late DateTime _selectedDate;
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate=widget.initialDate??DateTime.now();
    _displayMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
  }

  List<String> get _dayNames => ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  String _getWeekdayName(DateTime date) {
    const weekdays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return weekdays[date.weekday % 7];
  }

  String _formatHeaderDate(DateTime date) {
    return '${_getWeekdayName(_selectedDate)}, ${date.day} thg ${date
        .month}, ${date.year}';
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayMonth =
          DateTime(_displayMonth.year, _displayMonth.month + delta, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(
        _displayMonth.year, _displayMonth.month, 1);
    final lastDayOfMonth = DateTime(
        _displayMonth.year, _displayMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = ((firstDayOfMonth.weekday - 1) % 7);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatHeaderDate(_selectedDate),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'tháng ${_displayMonth.month} năm ${_displayMonth
                              .year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down, size: 24),
                      ],
                    ),
                    Row(
                      spacing: UIConstants.smallSpacing,
                      children: [
                        InkWell(onTap:(){
                        _changeMonth(-1);
                        }, child: Icon(Icons.arrow_back_ios_new, size: 18,)),
                        InkWell(onTap: (){
                          _changeMonth(1);

                        },child: Icon(Icons.arrow_forward_ios, size: 18,))
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemCount: 7 + firstWeekday + daysInMonth,
                  itemBuilder: (context, index) {
                    if (index < 7) {
                      return Center(
                        child: Text(
                          _dayNames[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }

                    final dayIndex = index - 7 - firstWeekday;
                    if (dayIndex < 0 || dayIndex >= daysInMonth) {
                      return const SizedBox();
                    }

                    final day = dayIndex + 1;
                    final date = DateTime(
                        _displayMonth.year, _displayMonth.month, day);
                    final isSelected = date.year == _selectedDate.year &&
                        date.month == _selectedDate.month &&
                        date.day == _selectedDate.day;

                    return GestureDetector(
                      onTap: () {
                        final now = DateTime.now();
                        final date = DateTime(_displayMonth.year, _displayMonth.month, day,
                            now.hour, now.minute, now.second, now.millisecond, now.microsecond);
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFDAA520) : Colors
                              .transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.black : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Hủy',
                          style: TextStyle(
                            color: Color(0xFFDAA520),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(_selectedDate);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDAA520),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Xác nhận',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}