import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constant/export.dart';
import '../../../../core/text_style/export.dart';
import '../../../../core/enum/export.dart';

class StatisticsHeader extends StatelessWidget {
  final TransactionType transactionType;
  final double totalAmount;
  final int transactionCount;

  const StatisticsHeader({
    super.key,
    required this.transactionType,
    required this.totalAmount,
    required this.transactionCount,
  });

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateTime.now();
    final monthName = DateFormat('MMMM yyyy', 'vi').format(currentMonth);

    return Container(
      margin: const EdgeInsets.all(UIConstants.smallPadding),
      padding: const EdgeInsets.all(UIConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_getPrimaryColor(), _getPrimaryColor().withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
        boxShadow: [
          BoxShadow(
            color: _getPrimaryColor().withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('Tổng $monthName', style: AppTextStyle.whiteS16),
          const SizedBox(height: UIConstants.smallPadding),
          Text(_formatAmount(totalAmount), style: AppTextStyle.whiteS24Bold),
          const SizedBox(height: UIConstants.smallPadding / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Số giao dịch',
                transactionCount.toString(),
                Icons.receipt_long,
              ),
              _buildStatItem(
                'Trung bình/ngày',
                _calculateDailyAverage().toString(),
                Icons.trending_up,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: UIConstants.defaultIconSize),
        const SizedBox(height: UIConstants.smallPadding / 2),
        Text(value, style: AppTextStyle.whiteS18Bold),
        Text(label, style: AppTextStyle.whiteS12),
      ],
    );
  }

  Color _getPrimaryColor() {
    switch (transactionType) {
      case TransactionType.income:
        return ColorConstants.secondary;
      case TransactionType.expense:
        return ColorConstants.primary;
      case TransactionType.transfer:
        return ColorConstants.primary;
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

  int _calculateDailyAverage() {
    final daysInMonth = DateTime.now().day;
    return (transactionCount / daysInMonth).round();
  }
}
