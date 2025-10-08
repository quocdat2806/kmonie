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

  static String formatFullDate(DateTime date) {
    return DateFormat('d MMM yyyy HH:mm:ss', 'vi_VN').format(date);
  }


  static String toDateString(DateTime? dateTime, {String format = AppConfigs.dateDisplayFormat}) {
    try {
      return dateTime != null ? DateFormat(format).format(dateTime.toLocal()) : '';
    } catch (e) {
      return '';
    }
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

  static String toDateTimeString(DateTime? dateTime, {String format = AppConfigs.dateTimeDisplayFormat}) {
    try {
      return dateTime != null ? DateFormat(format).format(dateTime.toLocal()) : '';
    } catch (e) {
      return '';
    }
  }

  static String toDateAPIString(DateTime? dateTime, {String format = AppConfigs.dateDisplayFormat}) {
    try {
      return dateTime != null ? DateFormat(format).format(dateTime) : '';
    } catch (e) {
      return '';
    }
  }

  static String toDateTimeAPIString(DateTime? dateTime, {String format = AppConfigs.dateTimeAPIFormat}) {
    try {
      return dateTime != null ? DateFormat(format).format(dateTime) : '';
    } catch (e) {
      return '';
    }
  }

  static DateTime startOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static DateTime endOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
  }
}
