import 'package:intl/intl.dart';
import 'package:kmonie/core/constants/constants.dart';

class FormatUtils {
  FormatUtils._();
  static String formatCurrency(int amount) {
    if (amount == 0) return '0';
    return NumberFormat.currency(locale: 'vi_VN', symbol: '').format(amount);
  }

  static String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  static String formatCurrentMonthLabel(DateTime month) {
    final now = DateTime.now();
    if (month.year == now.year && month.month == now.month) {
      return AppTextConstants.thisMonth;
    }
    return 'T${month.month}/${month.year}';
  }

  static String formatCurrentYearLabel(int year) {
    final now = DateTime.now();
    if (year == now.year) {
      return AppTextConstants.thisYear;
    }
    return '${AppTextConstants.year} $year';
  }

  static String formatDailyTransactionTotal(double income, double expense) {
    if (income > 0 && expense > 0) {
      return 'Thu: ${_formatAmount(income)} | Chi: ${_formatAmount(expense)}';
    } else if (income > 0) {
      return 'Thu: ${_formatAmount(income)}';
    } else if (expense > 0) {
      return 'Chi: ${_formatAmount(expense)}';
    }
    return '';
  }
}
