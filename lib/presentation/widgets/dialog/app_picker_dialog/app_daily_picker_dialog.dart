import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/core/navigation/navigation.dart';

class DatePickerScreen extends StatefulWidget {
  final DateTime? initialDate;

  const DatePickerScreen({super.key, this.initialDate});

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  late DateTime _selectedDate;
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _displayMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_displayMonth.year, _displayMonth.month);
    final lastDayOfMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = ((firstDayOfMonth.weekday - 1) % 7);

    return Scaffold(
      backgroundColor: AppColorConstants.blackSemiTransparent,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(AppUIConstants.defaultMargin),
          decoration: BoxDecoration(color: AppColorConstants.white, borderRadius: BorderRadius.circular(AppUIConstants.largeBorderRadius)),
          child: Padding(
            padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
            child: Column(
              spacing: AppUIConstants.defaultSpacing,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppDateUtils.formatHeaderDate(_selectedDate), style: AppTextStyle.blackS24Bold),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [Text('${AppTextConstants.month} ${_displayMonth.month} ${AppTextConstants.year.toLowerCase()} ${_displayMonth.year}', style: AppTextStyle.blackS14)]),
                    Row(
                      spacing: AppUIConstants.defaultSpacing,
                      children: [
                        InkWell(
                          onTap: () {
                            _changeMonth(-1);
                          },
                          child: const Icon(Icons.arrow_back_ios_new, size: AppUIConstants.smallIconSize),
                        ),
                        InkWell(
                          onTap: () {
                            _changeMonth(1);
                          },
                          child: const Icon(Icons.arrow_forward_ios, size: AppUIConstants.smallIconSize),
                        ),
                      ],
                    ),
                  ],
                ),
                AppGrid(
                  crossAxisCount: 7,
                  itemCount: 7 + firstWeekday + daysInMonth,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index < 7) {
                      return Center(child: Text(AppDateUtils.weekdays[index], style: AppTextStyle.blackS14Medium));
                    }

                    final dayIndex = index - 7 - firstWeekday;
                    if (dayIndex < 0 || dayIndex >= daysInMonth) {
                      return const SizedBox();
                    }

                    final day = dayIndex + 1;
                    final date = DateTime(_displayMonth.year, _displayMonth.month, day);
                    final isSelected = AppDateUtils.isSameDate(date, _selectedDate);

                    return GestureDetector(
                      onTap: () {
                        final now = DateTime.now();
                        final date = DateTime(_displayMonth.year, _displayMonth.month, day, now.hour, now.minute, now.second, now.millisecond, now.microsecond);
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(color: isSelected ? AppColorConstants.primary : Colors.transparent, shape: BoxShape.circle),
                        child: Center(child: Text('$day', style: isSelected ? AppTextStyle.blackS14Bold : AppTextStyle.blackS14Medium)),
                      ),
                    );
                  },
                ),
                // GridView.builder(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4),
                //   itemCount: 7 + firstWeekday + daysInMonth,
                //   itemBuilder: (context, index) {
                //     if (index < 7) {
                //       return Center(child: Text(AppDateUtils.weekdays[index], style: AppTextStyle.blackS14Medium));
                //     }

                //     final dayIndex = index - 7 - firstWeekday;
                //     if (dayIndex < 0 || dayIndex >= daysInMonth) {
                //       return const SizedBox();
                //     }

                //     final day = dayIndex + 1;
                //     final date = DateTime(_displayMonth.year, _displayMonth.month, day);
                //     final isSelected = AppDateUtils.isSameDate(date, _selectedDate);

                //     return GestureDetector(
                //       onTap: () {
                //         final now = DateTime.now();
                //         final date = DateTime(_displayMonth.year, _displayMonth.month, day, now.hour, now.minute, now.second, now.millisecond, now.microsecond);
                //         setState(() {
                //           _selectedDate = date;
                //         });
                //       },
                //       child: Container(
                //         decoration: BoxDecoration(color: isSelected ? AppColorConstants.primary : Colors.transparent, shape: BoxShape.circle),
                //         child: Center(child: Text('$day', style: isSelected ? AppTextStyle.blackS14Bold : AppTextStyle.blackS14Medium)),
                //       ),
                //     );
                //   },
                // ),
                Row(
                  spacing: AppUIConstants.defaultSpacing,
                  children: [
                    Expanded(
                      child: AppButton(
                        text: AppTextConstants.cancel,
                        onPressed: () {
                          AppNavigator(context: context).pop();
                        },
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        text: AppTextConstants.confirm,
                        onPressed: () {
                          AppNavigator(context: context).pop(_selectedDate);
                        },
                        backgroundColor: Colors.transparent,
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
