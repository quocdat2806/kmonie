import 'package:flutter/material.dart';

import 'package:kmonie/presentation/widgets/chart/app_chart.dart';

class ExpenseItem {
  final String name;
  final double percent;
  final double amount;
  final Color color;
  final IconData icon;

  ExpenseItem({
    required this.name,
    required this.percent,
    required this.amount,
    required this.color,
    required this.icon,
  });
}

class ExpenseChartPage extends StatelessWidget {
  ExpenseChartPage({super.key});

  final List<ExpenseItem> items = [
    ExpenseItem(
      name: "Nhà ở",
      percent: 66.66,
      amount: 2000000,
      color: Colors.yellow,
      icon: Icons.format_paint,
    ),
    ExpenseItem(
      name: "Đồ ăn",
      percent: 16.66,
      amount: 500000,
      color: Colors.pinkAccent,
      icon: Icons.restaurant,
    ),
    ExpenseItem(
      name: "Mua sắm",
      percent: 10,
      amount: 300000,
      color: Colors.cyan,
      icon: Icons.shopping_cart,
    ),
    ExpenseItem(
      name: "Xe hơi",
      percent: 6.66,
      amount: 200000,
      color: Colors.green,
      icon: Icons.directions_car,
    ),
  ];

  String formatCurrency(double value) {
    return "${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}";
  }

  @override
  Widget build(BuildContext context) {
    final chartData = items
        .map((e) => ChartData(e.name, e.percent, e.color))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Thống kê chi tiêu")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Chart + Legend
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppChart(data: chartData, size: 150, strokeWidth: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: items
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: e.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "${e.name} ${e.percent.toStringAsFixed(2)}%",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// Danh sách chi tiết
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final e = items[index];
                  return Row(
                    children: [
                      /// Icon tròn
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: e.color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(e.icon, color: e.color, size: 20),
                      ),
                      const SizedBox(width: 12),

                      /// Tên + % + progress
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${e.name} ${e.percent.toStringAsFixed(2)}%",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  formatCurrency(e.amount),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: e.percent / 100,
                                backgroundColor: Colors.grey.shade200,
                                color: e.color,
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
