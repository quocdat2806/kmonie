import 'package:intl/intl.dart';

import 'package:kmonie/core/config/config.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatDateKey(DateTime date) {
    return DateFormat(AppConfigs.dateDisplayFormat).format(date);
  }

  static DateTime parseDateKey(String dateKey) {
    return DateFormat(AppConfigs.dateDisplayFormat).parse(dateKey);
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

  static List<DateTime> generateRecentMonths({int initialMonthCount = 12}) {
    final DateTime now = DateTime.now();
    final List<DateTime> months = [];
    for (int i = initialMonthCount - 1; i >= 0; i--) {
      months.add(DateTime(now.year, now.month - i));
    }
    return months;
  }

  static List<int> generateRecentYears({int rangeBack = 5}) {
    final DateTime now = DateTime.now();
    final List<int> years = [];
    for (int i = rangeBack; i >= 0; i--) {
      years.add(now.year - i);
    }
    return years;
  }

  static List<DateTime> generateMoreMonths(
    List<DateTime> currentMonths, {
    int addCount = 12,
  }) {
    if (currentMonths.isEmpty) return currentMonths;
    final List<DateTime> newMonths = [];
    final DateTime oldestMonth = currentMonths.first;
    for (int i = addCount; i >= 1; i--) {
      newMonths.add(DateTime(oldestMonth.year, oldestMonth.month - i));
    }
    return [...newMonths, ...currentMonths];
  }

  static List<int> generateMoreYears(
    List<int> currentYears, {
    int rangeBack = 5,
  }) {
    if (currentYears.isEmpty) return currentYears;
    final List<int> newYears = [];
    final int oldestYear = currentYears.first;
    for (int i = rangeBack; i >= 1; i--) {
      newYears.add(oldestYear - i);
    }
    return [...newYears, ...currentYears];
  }

  static ({DateTime startUtc, DateTime endUtc}) monthRangeUtc(
    int year,
    int month,
  ) {
    final localStart = DateTime(year, month);
    final localNext = (month == 12)
        ? DateTime(year + 1)
        : DateTime(year, month + 1);
    return (startUtc: localStart.toUtc(), endUtc: localNext.toUtc());
  }

  static ({DateTime startUtc, DateTime endUtc}) yearRangeUtc(int year) {
    final localStart = DateTime(year);
    final localNext = DateTime(year + 1);
    return (startUtc: localStart.toUtc(), endUtc: localNext.toUtc());
  }
}
