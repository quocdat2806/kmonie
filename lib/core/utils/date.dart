import 'package:intl/intl.dart';

import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/entities/entities.dart';

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

  static String formatHeaderDate(DateTime date) {
    const weekdays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    final weekdayName = weekdays[date.weekday % 7];
    return '$weekdayName, ${date.day} thg ${date.month}, ${date.year}';
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

  // ========== TRANSACTION DATE HELPER METHODS ==========

  /// Check if a transaction belongs to the current month
  static bool isTransactionInCurrentMonth(
    Transaction transaction,
    DateTime currentDate,
  ) {
    final txDate = transaction.date;
    return txDate.year == currentDate.year && txDate.month == currentDate.month;
  }

  /// Check if a transaction belongs to a specific month
  static bool isTransactionInMonth(
    Transaction transaction,
    DateTime targetDate,
  ) {
    final txDate = transaction.date;
    return txDate.year == targetDate.year && txDate.month == targetDate.month;
  }

  /// Check if a transaction belongs to the current year
  static bool isTransactionInCurrentYear(
    Transaction transaction,
    DateTime currentDate,
  ) {
    final txDate = transaction.date;
    return txDate.year == currentDate.year;
  }

  /// Check if a transaction belongs to a specific year
  static bool isTransactionInYear(
    Transaction transaction,
    DateTime targetDate,
  ) {
    final txDate = transaction.date;
    return txDate.year == targetDate.year;
  }

  /// Check if a transaction belongs to the current quarter
  static bool isTransactionInCurrentQuarter(
    Transaction transaction,
    DateTime currentDate,
  ) {
    final txDate = transaction.date;
    if (txDate.year != currentDate.year) return false;

    final currentQuarter = _getQuarter(currentDate.month);
    final txQuarter = _getQuarter(txDate.month);

    return currentQuarter == txQuarter;
  }

  /// Check if a transaction belongs to a specific quarter
  static bool isTransactionInQuarter(
    Transaction transaction,
    DateTime targetDate,
  ) {
    final txDate = transaction.date;
    if (txDate.year != targetDate.year) return false;

    final targetQuarter = _getQuarter(targetDate.month);
    final txQuarter = _getQuarter(txDate.month);

    return targetQuarter == txQuarter;
  }

  /// Check if a transaction belongs to the current week
  static bool isTransactionInCurrentWeek(
    Transaction transaction,
    DateTime currentDate,
  ) {
    final txDate = transaction.date;
    final startOfWeek = _getStartOfWeek(currentDate);
    final endOfWeek = _getEndOfWeek(currentDate);

    return txDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        txDate.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if a transaction belongs to a specific week
  static bool isTransactionInWeek(
    Transaction transaction,
    DateTime targetDate,
  ) {
    final txDate = transaction.date;
    final startOfWeek = _getStartOfWeek(targetDate);
    final endOfWeek = _getEndOfWeek(targetDate);

    return txDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        txDate.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if a transaction belongs to the current day
  static bool isTransactionInCurrentDay(
    Transaction transaction,
    DateTime currentDate,
  ) {
    final txDate = transaction.date;
    return txDate.year == currentDate.year &&
        txDate.month == currentDate.month &&
        txDate.day == currentDate.day;
  }

  /// Check if a transaction belongs to a specific day
  static bool isTransactionInDay(Transaction transaction, DateTime targetDate) {
    final txDate = transaction.date;
    return txDate.year == targetDate.year &&
        txDate.month == targetDate.month &&
        txDate.day == targetDate.day;
  }

  /// Check if a transaction is within a date range (inclusive)
  static bool isTransactionInDateRange(
    Transaction transaction,
    DateTime startDate,
    DateTime endDate,
  ) {
    final txDate = transaction.date;
    return txDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
        txDate.isBefore(endDate.add(const Duration(days: 1)));
  }

  // ========== DATE RANGE UTILITY METHODS ==========

  /// Get start of month
  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime getEndOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Get start of year
  static DateTime getStartOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Get end of year
  static DateTime getEndOfYear(DateTime date) {
    return DateTime(date.year, 12, 31);
  }

  /// Get start of quarter
  static DateTime getStartOfQuarter(DateTime date) {
    final quarter = _getQuarter(date.month);
    final month = (quarter - 1) * 3 + 1;
    return DateTime(date.year, month, 1);
  }

  /// Get end of quarter
  static DateTime getEndOfQuarter(DateTime date) {
    final quarter = _getQuarter(date.month);
    final month = quarter * 3;
    return DateTime(date.year, month + 1, 0);
  }

  // ========== PRIVATE HELPER METHODS ==========

  /// Get quarter number from month (1-4)
  static int _getQuarter(int month) {
    if (month <= 3) return 1;
    if (month <= 6) return 2;
    if (month <= 9) return 3;
    return 4;
  }

  /// Get start of week (Monday)
  static DateTime _getStartOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }

  /// Get end of week (Sunday)
  static DateTime _getEndOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return DateTime(date.year, date.month, date.day + daysToSunday);
  }
}
