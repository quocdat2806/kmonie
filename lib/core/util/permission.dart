import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../presentation/widgets/exports.dart';
import '../di/export.dart' show sl;
import '../service/exports.dart';
class PermissionUtils {
  PermissionUtils._();
  static Future<bool> requestPhotosPermission(BuildContext context) async {
    final bool isSdkLessThan33 =
        Platform.isAndroid &&
        ((await DeviceInfoPlugin().androidInfo).version.sdkInt < 33);

    if (isSdkLessThan33) {
      if (context.mounted) {
        return await requestStoragePermission(context);
      }
    } else if (await Permission.photos.isGranted) {
      return true;
    } else {
      final PermissionStatus status = await Permission.photos.request();
      if (status.isGranted || status.isLimited) {
        return true;
      } else if (status.isPermanentlyDenied) {
        if (context.mounted) {
          await showOpenAppSettingsDialog(context);
        }
      }
    }
    return false;
  }

  static Future<bool> requestStoragePermission(BuildContext context) async {
    if (await Permission.storage.isGranted) {
      return true;
    } else {
      final PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        if (context.mounted) {
          await showOpenAppSettingsDialog(context);
        }
      }
    }
    return false;
  }


  static Future<bool> requestCameraPermission(BuildContext context) async {
    if (await Permission.camera.isGranted) {
      return true;
    } else {
      final PermissionStatus status = await Permission.camera.request();
      if (status.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        if (context.mounted) {
          await showOpenAppSettingsDialog(context);
        }
      }
    }
    return false;
  }
  static Future<bool> requestNotificationService() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      if(granted==true){
         sl<NotificationService>().scheduleDailyReminder();
      }
      return granted ?? false;
    }

    return false;
  }

  static Future<void> showOpenAppSettingsDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const AppSettingDialog();
      },
    );
  }
}
