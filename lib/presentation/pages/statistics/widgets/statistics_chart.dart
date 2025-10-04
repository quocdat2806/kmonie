import 'package:flutter/material.dart';
import '../../../../core/constant/export.dart';
import '../../../../core/text_style/export.dart';
import '../../../../core/enum/export.dart';
import '../../../../entity/export.dart';

class StatisticsChart extends StatelessWidget {
  final Map<String, List<Transaction>> groupedTransactions;
  final Map<int, TransactionCategory> categoriesMap;
  final TransactionType transactionType;

  const StatisticsChart({
    super.key,
    required this.groupedTransactions,
    required this.categoriesMap,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context) {
    final chartData = _prepareChartData();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: UIConstants.smallPadding),
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
          Text('Biểu đồ theo ngày', style: AppTextStyle.blackS16Bold),
          const SizedBox(height: UIConstants.smallPadding),
          if (chartData.isEmpty) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(UIConstants.defaultPadding),
                child: Text('Không có dữ liệu để hiển thị'),
              ),
            ),
          ] else ...[
            SizedBox(height: 200, child: _buildBarChart(chartData)),
            const SizedBox(height: UIConstants.smallPadding),
            _buildLegend(),
          ],
        ],
      ),
    );
  }

  Widget _buildBarChart(List<ChartData> data) {
    final maxAmount = data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: data.map((item) {
        final height = (item.amount / maxAmount) * 150;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(_formatAmount(item.amount), style: AppTextStyle.greyS12),
            const SizedBox(height: 4),
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(
                color: _getBarColor(),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Text(item.day, style: AppTextStyle.greyS12),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _getBarColor(),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: UIConstants.smallPadding / 2),
        Text(_getTypeLabel(), style: AppTextStyle.greyS12),
      ],
    );
  }

  List<ChartData> _prepareChartData() {
    final List<ChartData> data = [];

    // Lấy 7 ngày gần nhất có giao dịch
    final sortedDays = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    final recentDays = sortedDays.take(7).toList();

    for (final day in recentDays) {
      final transactions = groupedTransactions[day]!;
      final totalAmount = transactions.fold(0.0, (sum, t) => sum + t.amount);

      data.add(
        ChartData(
          day: day.split('/')[0], // Chỉ lấy ngày
          amount: totalAmount,
        ),
      );
    }

    return data;
  }

  Color _getBarColor() {
    switch (transactionType) {
      case TransactionType.income:
        return ColorConstants.secondary;
      case TransactionType.expense:
        return ColorConstants.primary;
      case TransactionType.transfer:
        return ColorConstants.primary;
    }
  }

  String _getTypeLabel() {
    switch (transactionType) {
      case TransactionType.income:
        return 'Thu nhập';
      case TransactionType.expense:
        return 'Chi tiêu';
      case TransactionType.transfer:
        return 'Chuyển khoản';
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

class ChartData {
  final String day;
  final double amount;

  ChartData({required this.day, required this.amount});
}
