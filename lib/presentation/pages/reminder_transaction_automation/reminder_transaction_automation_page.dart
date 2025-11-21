import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/core/utils/utils.dart';

class ReminderTransactionAutomationPage extends StatefulWidget {
  const ReminderTransactionAutomationPage({super.key});

  @override
  State<ReminderTransactionAutomationPage> createState() =>
      _ReminderTransactionAutomationPageState();
}

class _ReminderTransactionAutomationPageState
    extends State<ReminderTransactionAutomationPage> {
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  final Set<int> _selectedDays = {7};

  @override
  void initState() {
    super.initState();
    _selectedTime = const TimeOfDay(hour: 7, minute: 0);
    _selectedDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dialOnly,
      helpText: '',
      hourLabelText: '',
      minuteLabelText: '',
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColorConstants.primary,
              onSurface: AppColorConstants.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => AppDatePickerDialog(initialDate: _selectedDate),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked as DateTime?;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour : $minute $period';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      final weekday = DateFormat('E', 'vi').format(date);
      final dayMonth = DateFormat('d MMM', 'vi').format(date);
      return 'Ngày mai-$weekday, $dayMonth';
    }

    final weekday = DateFormat('E', 'vi').format(date);
    final dayMonth = DateFormat('d MMM', 'vi').format(date);
    return '$weekday, $dayMonth';
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _save() {
    Navigator.of(context).pop();
  }

  void _exit() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.white,
      appBar: const CustomAppBar(title: AppTextConstants.autoSchedule),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: _selectTime,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppUIConstants.largePadding,
                        ),
                        child: Center(
                          child: Text(
                            _selectedTime != null
                                ? _formatTime(_selectedTime!)
                                : '07 : 00 AM',
                            style: AppTextStyle.blackS20Bold.copyWith(
                              fontSize: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppUIConstants.defaultSpacing),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: _selectDate,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedDate != null
                                          ? _formatDate(_selectedDate!)
                                          : 'Ngày mai-T.6, 21 Th11',
                                      style: AppTextStyle.blackS14Medium,
                                    ),
                                  ],
                                ),
                              ),
                              SvgUtils.icon(
                                assetPath: Assets.svgsCalendar,
                                size: SvgSizeType.medium,
                                color: AppColorConstants.primary,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppUIConstants.defaultSpacing),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildDayButton(2, '2'),
                            _buildDayButton(3, '3'),
                            _buildDayButton(4, '4'),
                            _buildDayButton(5, '5'),
                            _buildDayButton(6, '6'),
                            _buildDayButton(7, '7'),
                            _buildDayButton(0, 'CN'),
                          ],
                        ),
                        const SizedBox(height: AppUIConstants.largeSpacing),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
              decoration: AppUIConstants.defaultShadow(),
              child: Row(
                spacing: AppUIConstants.defaultSpacing,
                children: [
                  Expanded(
                    child: AppButton(
                      text: AppTextConstants.exit,
                      backgroundColor: Colors.transparent,
                      onPressed: _exit,
                    ),
                  ),
                  Expanded(
                    child: AppButton(
                      text: AppTextConstants.save,
                      onPressed: _save,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayButton(int day, String label) {
    final isSelected = _selectedDays.contains(day);
    return InkWell(
      onTap: () => _toggleDay(day),
      borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? (day == 7
                    ? AppColorConstants.secondary
                    : day == 0
                    ? AppColorConstants.red
                    : AppColorConstants.secondary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            AppUIConstants.defaultBorderRadius,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyle.blackS14Medium.copyWith(
              color: isSelected
                  ? AppColorConstants.white
                  : AppColorConstants.black,
            ),
          ),
        ),
      ),
    );
  }
}
