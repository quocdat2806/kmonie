class DateRangeUtils {
  DateRangeUtils._();

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

  static List<DateTime> generateMoreMonths(List<DateTime> currentMonths, {int addCount = 12}) {
    if (currentMonths.isEmpty) return currentMonths;
    final List<DateTime> newMonths = [];
    final DateTime oldestMonth = currentMonths.first;
    for (int i = addCount; i >= 1; i--) {
      newMonths.add(DateTime(oldestMonth.year, oldestMonth.month - i));
    }
    return [...newMonths, ...currentMonths];
  }

  static List<int> generateMoreYears(List<int> currentYears, {int rangeBack = 5}) {
    if (currentYears.isEmpty) return currentYears;
    final List<int> newYears = [];
    final int oldestYear = currentYears.first;
    for (int i = rangeBack; i >= 1; i--) {
      newYears.add(oldestYear - i);
    }
    return [...newYears, ...currentYears];
  }
}
