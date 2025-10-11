import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class AppSettingDialog extends StatelessWidget {
  const AppSettingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
      ),
      title: const Text('Permission is Permanently Denied'),
      content: const Text(
        'The app needs permission access to function properly. \nPlease go to settings to grant permission.',
      ),
      actions: <Widget>[
        Row(
          spacing: AppUIConstants.smallSpacing,
          children: [
            Expanded(
              child: AppButton(
                onPressed: () => Navigator.of(context).pop(),
                text: AppTextConstants.cancel,
                backgroundColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: AppButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
                text: AppTextConstants.openSetting,
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
