import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AppSettingDialog extends StatelessWidget {
  const AppSettingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Permission is Permanently Denied'),
      content: const Text('The app needs permission access to function properly. \nPlease go to settings to grant permission.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            openAppSettings();
          },
          child: const Text('Open Settings'),
        ),
      ],
    );
  }
}
