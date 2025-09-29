import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constant/exports.dart';
import '../../../../core/text_style/export.dart';
import '../../../../core/enum/exports.dart';
import '../../../../entity/exports.dart';

class MonthlyStatistics extends StatelessWidget {
  final Map<String, List<Transaction>> groupedTransactions;
  final Map<int, TransactionCategory> categoriesMap;
  final TransactionType? selectedType;

  const MonthlyStatistics({
    super.key,
    required this.groupedTransactions,
    required this.categoriesMap,
    this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateTime.now();
    final monthName = DateFormat('MMMM yyyy', 'vi').format(currentMonth);

    final statistics = _calculateMonthlyStatistics();

    return Container(
      margin: const EdgeInsets.all(UIConstants.smallPadding),
      padding: const EdgeInsets.all(UIConstants.smallPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thống kê $monthName', style: AppTextStyle.blackS16Bold),
          const SizedBox(height: UIConstants.smallPadding),
          if (selectedType == null) ...[
            _buildStatItem(
              'Tổng thu nhập',
              statistics['income']!,
              ColorConstants.secondary,
            ),
            const SizedBox(height: UIConstants.smallPadding / 2),
            _buildStatItem(
              'Tổng chi tiêu',
              statistics['expense']!,
              ColorConstants.primary,
            ),
            const SizedBox(height: UIConstants.smallPadding / 2),
            _buildStatItem(
              'Số dư',
              statistics['balance']!,
              ColorConstants.black,
            ),
          ] else ...[
            _buildStatItem(
              selectedType == TransactionType.income
                  ? 'Tổng thu nhập'
                  : selectedType == TransactionType.expense
                  ? 'Tổng chi tiêu'
                  : 'Tổng chuyển khoản',
              statistics[selectedType == TransactionType.income
                  ? 'income'
                  : selectedType == TransactionType.expense
                  ? 'expense'
                  : 'transfer']!,
              selectedType == TransactionType.income
                  ? ColorConstants.secondary
                  : ColorConstants.primary,
            ),
          ],
          const SizedBox(height: UIConstants.smallPadding),
          _buildDaysSummary(),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, double amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.greyS14),
        Text(
          _formatAmount(amount),
          style: AppTextStyle.blackS16Bold.copyWith(color: color),
        ),
      ],
    );
  }

  Widget _buildDaysSummary() {
    final daysWithTransactions = _getDaysWithTransactions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Các ngày có giao dịch:', style: AppTextStyle.greyS12),
        const SizedBox(height: UIConstants.smallPadding / 2),
        Wrap(
          spacing: UIConstants.smallPadding / 2,
          runSpacing: UIConstants.smallPadding / 2,
          children: daysWithTransactions.map((day) {
            final dayTransactions = groupedTransactions[day]!;
            final dayStats = _calculateDayStatistics(dayTransactions);

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.smallPadding / 2,
                vertical: UIConstants.smallPadding / 4,
              ),
              decoration: BoxDecoration(
                color: _getDayColor(dayStats),
                borderRadius: BorderRadius.circular(
                  UIConstants.smallBorderRadius / 2,
                ),
              ),
              child: Text(day, style: AppTextStyle.whiteS10),
            );
          }).toList(),
        ),
      ],
    );
  }

  Map<String, double> _calculateMonthlyStatistics() {
    double income = 0;
    double expense = 0;
    double transfer = 0;

    for (final dayTransactions in groupedTransactions.values) {
      for (final transaction in dayTransactions) {
        final category = categoriesMap[transaction.transactionCategoryId];
        if (category == null) continue;

        switch (category.transactionType) {
          case TransactionType.income:
            income += transaction.amount;
            break;
          case TransactionType.expense:
            expense += transaction.amount;
            break;
          case TransactionType.transfer:
            transfer += transaction.amount;
            break;
        }
      }
    }

    return {
      'income': income,
      'expense': expense,
      'transfer': transfer,
      'balance': income - expense,
    };
  }

  List<String> _getDaysWithTransactions() {
    return groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Mới nhất trước
  }

  Map<String, double> _calculateDayStatistics(List<Transaction> transactions) {
    double income = 0;
    double expense = 0;

    for (final transaction in transactions) {
      final category = categoriesMap[transaction.transactionCategoryId];
      if (category == null) continue;

      if (category.transactionType == TransactionType.income) {
        income += transaction.amount;
      } else if (category.transactionType == TransactionType.expense) {
        expense += transaction.amount;
      }
    }

    return {'income': income, 'expense': expense};
  }

  Color _getDayColor(Map<String, double> dayStats) {
    if (dayStats['income']! > dayStats['expense']!) {
      return ColorConstants.secondary; // Thu nhiều hơn chi
    } else if (dayStats['expense']! > dayStats['income']!) {
      return ColorConstants.primary; // Chi nhiều hơn thu
    } else {
      return ColorConstants.grey; // Cân bằng
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}Mđ';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}Kđ';
    }
    return '${amount.toStringAsFixed(0)}đ';
  }
}
