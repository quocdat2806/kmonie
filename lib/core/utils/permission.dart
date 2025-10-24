import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kmonie/core/di/di.dart' show sl;
import 'package:kmonie/core/services/services.dart';

class PermissionUtils {
  PermissionUtils._();

  static Future<bool> requestNotificationService() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      if (granted == true) {
        sl<NotificationService>().scheduleDailyReminder();
      }
      return granted ?? false;
    }

    return false;
  }
}
