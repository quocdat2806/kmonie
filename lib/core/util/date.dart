import 'package:intl/intl.dart';

import '../config/export.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatDateKey(DateTime date) {
    return DateFormat(AppConfigs.dateDisplayFormat).format(date);
  }

  static String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy', 'vi_VN').format(date);
  }
  static String formatDateMonthAndDay(DateTime date) {
    return DateFormat('d MMM', 'vi_VN').format(date);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('d MMM yyyy HH:mm:ss', 'vi_VN').format(date);
  }

  static ({DateTime startUtc, DateTime endUtc}) monthRangeUtc(int year, int month) {
    final localStart = DateTime(year, month);
    final localNext = (month == 12) ? DateTime(year + 1) : DateTime(year, month + 1);
    return (startUtc: localStart.toUtc(), endUtc: localNext.toUtc());
  }

  static ({DateTime startUtc, DateTime endUtc}) yearRangeUtc(int year) {
    final localStart = DateTime(year);
    final localNext = DateTime(year + 1);
    return (startUtc: localStart.toUtc(), endUtc: localNext.toUtc());
  }
}
