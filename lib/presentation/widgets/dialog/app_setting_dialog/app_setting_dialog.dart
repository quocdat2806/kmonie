import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constant/export.dart';
import '../../../widgets/export.dart';

class AppSettingDialog extends StatelessWidget {
  const AppSettingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius)),
      title: const Text('Permission is Permanently Denied'),
      content: const Text('The app needs permission access to function properly. \nPlease go to settings to grant permission.'),
      actions: <Widget>[
        Row(
          spacing: UIConstants.smallSpacing,
          children: [
            Expanded(
              child: AppButton(onPressed: () => Navigator.of(context).pop(), text: TextConstants.cancel, backgroundColor: Colors.transparent),
            ),
            Expanded(
              child: AppButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
                text: TextConstants.openSetting,
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
