class ChartFormatUtils {
  ChartFormatUtils._();

  static String formatMonthLabel(DateTime month) {
    final now = DateTime.now();
    if (month.year == now.year && month.month == now.month) {
      return 'Tháng này';
    }
    return 'T${month.month}/${month.year}';
  }

  static String formatYearLabel(int year) {
    final now = DateTime.now();
    if (year == now.year) {
      return 'Năm nay';
    }
    return 'Năm $year';
  }
}
