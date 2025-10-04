import 'package:flutter/material.dart';
import '../../../core/constant/export.dart';
import '../../../core/enum/income_type.dart';
import '../../widgets/export.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final GlobalKey _dropdownKey = GlobalKey();
  String selected = 'Tháng';

  final List<String> options = ExIncomeType.toList;

  final List<DateTime> _months = [];
  int _selectedMonthIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _generateMonths();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _generateMonths({bool isLoadMore = false}) {
    DateTime now = DateTime.now();
    const int initialMonthCount = 12; // Bắt đầu với 12 tháng

    if (!isLoadMore) {
      // Khởi tạo lần đầu
      _months.clear();
      for (int i = initialMonthCount - 1; i >= 0; i--) {
        final month = DateTime(now.year, now.month - i);
        _months.add(month);
      }
      _selectedMonthIndex = _months.length - 1; // Tháng này ở cuối danh sách
    } else {
      // Load thêm 12 tháng cũ hơn
      List<DateTime> newMonths = [];
      DateTime oldestMonth = _months.first;

      for (int i = 12; i >= 1; i--) {
        final month = DateTime(oldestMonth.year, oldestMonth.month - i);
        newMonths.add(month);
      }

      // Thêm vào đầu danh sách và cập nhật selectedIndex
      int currentSelectedIndex = _selectedMonthIndex;
      _months.insertAll(0, newMonths);
      _selectedMonthIndex = currentSelectedIndex + newMonths.length;
    }
  }

  void _loadMoreMonths() {
    setState(() {
      _generateMonths(isLoadMore: true);
    });
  }

  String _formatMonthLabel(DateTime month) {
    final now = DateTime.now();
    if (month.year == now.year && month.month == now.month) {
      return 'Tháng này';
    }
    return 'T${month.month}/${month.year}';
  }

  void _showDropdown() {
    CustomDropdownOverlay.show<String>(
      context: context,
      targetKey: _dropdownKey,
      items: options,
      itemBuilder: (item) => Padding(
        padding: const EdgeInsets.all(12),
        child: Text(item, style: const TextStyle(color: Colors.black)),
      ),
      onItemSelected: (value) {
        setState(() => selected = value);
      },
    );
  }

  Widget _buildMonthSelector(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        reverse:
            true, // ✅ Đảo ngược ListView để tháng mới nhất hiển thị đầu tiên
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _months.length + 1, // +1 để thêm nút Load More
        cacheExtent: 40,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          // Item cuối cùng là nút Load More
          if (index == _months.length) {
            return GestureDetector(
              onTap: _loadMoreMonths,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.chevron_left, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Xem thêm',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ✅ Tính lại actualIndex vì ListView bị reverse
          final actualIndex = _months.length - 1 - index;
          final month = _months[actualIndex];
          final isSelected = actualIndex == _selectedMonthIndex;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedMonthIndex = actualIndex);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatMonthLabel(month),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Chart data
  final List<ChartData> _chartData = [
    ChartData('', 45, const Color(0xFF4CAF50)), // Green
    ChartData('', 31, const Color(0xFFFFC107)), // Yellow
    ChartData('', 16, const Color(0xFFFF5722)), // Red
    ChartData('', 8, const Color(0xFF2196F3)), // Blue
  ];
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: ExpenseChartPage(),
      // child: Padding(
      //   padding: const EdgeInsets.all(16),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       GestureDetector(
      //         key: _dropdownKey,
      //         onTap: _showDropdown,
      //         child: Row(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Text(selected, style: const TextStyle(color: Colors.black)),
      //             const SizedBox(width: 8),
      //             SvgPicture.asset(
      //               Assets.svgsArrowDown,
      //               color: Colors.black,
      //               height: 16,
      //             ),
      //           ],
      //         ),
      //       ),
      //       const SizedBox(height: 12),
      //       AppTabView(
      //         types: IncomeConstants.incomeTypes,
      //         selectedIndex: 0,
      //         getDisplayName: (type) => type.displayName,
      //         getTypeIndex: (type) => type.typeIndex,
      //         onTabSelected: (index) {},
      //       ),
      //       const SizedBox(height: 12),
      //       _buildMonthSelector(context),
      //       Center(
      //         child: DonutChart(
      //           data: _chartData,
      //           size: 250,
      //           strokeWidth: 50,
      //         ),
      //       ),
      //       ExpenseChartPage()
      //     ],
      //   ),
      // ),
    );
  }
}
