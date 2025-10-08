import 'package:intl/intl.dart';

class FormatUtils {
  FormatUtils._();
  static String formatAmount(int amount) {
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

  static String formatTotalText(double income, double expense, double? transfer) {
    if (income > 0 && expense > 0) {
      return 'Thu: ${_formatAmount(income)} | Chi: ${_formatAmount(expense)}';
    } else if (income > 0) {
      return 'Thu: ${_formatAmount(income)}';
    } else if (expense > 0) {
      return 'Chi: ${_formatAmount(expense)}';
    } else if (transfer != null && transfer > 0) {
      return 'CK: ${_formatAmount(transfer)}';
    }
    return '';
  }
}
