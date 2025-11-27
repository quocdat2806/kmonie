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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReminderTime();
  }

  Future<void> _loadReminderTime() async {
    try {
      final reminderTime = await sl<ReminderService>().getReminderTime();
      if (mounted) {
        setState(() {
          if (reminderTime != null) {
            _selectedTime = TimeOfDay(
              hour: reminderTime.hour,
              minute: reminderTime.minute,
            );
          } else {
            _selectedTime = const TimeOfDay(hour: 21, minute: 15);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      logger.e('Error loading reminder time: $e');
      if (mounted) {
        setState(() {
          _selectedTime = const TimeOfDay(hour: 21, minute: 15);
          _isLoading = false;
        });
      }
    }
  }

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
                    _isLoading
                        ? '21:15'
                        : _selectedTime != null
                        ? AppDateUtils.formatTimeOfDay(_selectedTime!)
                        : '21:15',
                    style: AppTextStyle.blackS14Medium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppUIConstants.defaultSpacing),
            TimePickerWidget(
              selectedTime: _isLoading
                  ? const TimeOfDay(hour: 21, minute: 15)
                  : _selectedTime ?? const TimeOfDay(hour: 21, minute: 15),
              onTimeChanged: _onTimeChanged,
            ),
            const SizedBox(height: AppUIConstants.defaultSpacing),
            AppButton(
              width: 120,
              onPressed: () async {
                if (_selectedTime != null) {
                  try {
                    await sl<ReminderService>().saveReminderTime(
                      hour: _selectedTime!.hour,
                      minute: _selectedTime!.minute,
                    );
                    await sl<NotificationService>().scheduleDailyReminder(
                      hour: _selectedTime!.hour,
                      minute: _selectedTime!.minute,
                    );
                    if (mounted && context.mounted) {
                      AppNavigator(context: context).pop();
                    }
                  } catch (e) {
                    logger.e('Error saving reminder: $e');
                    await sl<NotificationService>().scheduleDailyReminder(
                      hour: _selectedTime!.hour,
                      minute: _selectedTime!.minute,
                    );
                    if (mounted && context.mounted) {
                      AppNavigator(context: context).pop();
                    }
                  }
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
