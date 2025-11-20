import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/core/di/di.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  TimeOfDay? _selectedTime;

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
      await sl<NotificationService>().scheduleDailyReminder(
        hour: picked.hour,
        minute: picked.minute,
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.white,
      appBar: const CustomAppBar(title: AppTextConstants.reminder),
      body: Padding(
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: _selectTime,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTextConstants.reminder,
                style: AppTextStyle.blackS14Medium,
              ),
              Text(
                _selectedTime != null ? AppDateUtils.formatTimeOfDay(_selectedTime!) : '21:00',
                style: AppTextStyle.blackS14Medium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
