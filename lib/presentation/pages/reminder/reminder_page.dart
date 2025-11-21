import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/navigation/navigation.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  TimeOfDay? _selectedTime;

  void _onTimeChanged(TimeOfDay time) async {
    if (_selectedTime != time) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.white,
      appBar: const CustomAppBar(title: AppTextConstants.reminder),
      body: Padding(
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        child: Column(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppTextConstants.reminder,
                    style: AppTextStyle.blackS14Medium,
                  ),
                  Text(
                    _selectedTime != null
                        ? AppDateUtils.formatTimeOfDay(_selectedTime!)
                        : '21:15',
                    style: AppTextStyle.blackS14Medium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppUIConstants.defaultSpacing),
            TimePickerWidget(
              selectedTime:
                  _selectedTime ?? const TimeOfDay(hour: 21, minute: 15),
              onTimeChanged: _onTimeChanged,
            ),
            const SizedBox(height: AppUIConstants.defaultSpacing),
            AppButton(
              width: 120,
              onPressed: () async {
                await sl<NotificationService>().scheduleDailyReminder(
                  hour: _selectedTime!.hour,
                  minute: _selectedTime!.minute,
                );
                if (mounted && context.mounted) {
                  AppNavigator(context: context).pop();
                }
              },
              text: AppTextConstants.save,
            ),
          ],
        ),
      ),
    );
  }
}
