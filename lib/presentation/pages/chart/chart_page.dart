import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kmonie/generated/assets.dart';

import '../../../core/di/export.dart';
import '../../../core/enum/export.dart';
import '../../../core/service/export.dart';
import '../../../core/tool/export.dart';
import '../../../core/constant/export.dart';
import '../../bloc/export.dart';
import '../../widgets/export.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ChartBloc(sl<TransactionService>(), sl<TransactionCategoryService>()), child: const _ChartPageView());
  }
}

class _ChartPageView extends StatefulWidget {
  const _ChartPageView();

  @override
  State<_ChartPageView> createState() => _ChartPageViewState();
}

class _ChartPageViewState extends State<_ChartPageView> {
  final GlobalKey _dropdownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, state) {
        return ColoredBox(
          color: Colors.white,
          child: Column(
            children: [
              // Transaction type dropdown
              _buildTransactionTypeDropdown(context, state),

              // Period type tabs (Month/Year)
              _buildPeriodTypeTabs(context, state),

              // Month/Year selector
              _buildPeriodSelector(context, state),

              // Chart
              Expanded(child: _buildChart(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionTypeDropdown(BuildContext context, ChartState state) {
    return GestureDetector(
      key: _dropdownKey,
      onTap: () => _showTransactionTypeDropdown(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(state.selectedTransactionType.displayName, style: const TextStyle(color: Colors.black)),
          const SizedBox(width: 8),
          SvgPicture.asset(Assets.svgsArrowDown, color: Colors.black, height: 16),
        ],
      ),
    );
  }

  Widget _buildPeriodTypeTabs(BuildContext context, ChartState state) {
    return AppTabView(
      types: ExIncomeType.incomeTypes,
      selectedIndex: state.selectedPeriodType.typeIndex,
      getDisplayName: (t) => t.displayName,
      getTypeIndex: (t) => t.typeIndex,
      onTabSelected: (index) {
        context.read<ChartBloc>().add(ChangePeriodType(IncomeType.fromIndex(index)));
      },
    );
  }

  Widget _buildPeriodSelector(BuildContext context, ChartState state) {
    if (state.selectedPeriodType == IncomeType.month) {
      return _buildMonthSelector(context, state);
    } else {
      return _buildYearSelector(context, state);
    }
  }

  Widget _buildMonthSelector(BuildContext context, ChartState state) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: state.months.length + 1,
        cacheExtent: 40,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == state.months.length) {
            return GestureDetector(
              onTap: () => context.read<ChartBloc>().add(const LoadMoreMonths()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chevron_left, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Xem thêm',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }

          final actualIndex = state.months.length - 1 - index;
          final month = state.months[actualIndex];
          final isSelected = actualIndex == state.selectedMonthIndex;

          return GestureDetector(
            onTap: () {
              context.read<ChartBloc>().add(SelectMonth(actualIndex));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: isSelected ? Colors.black : Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
              child: Text(
                _formatMonthLabel(month),
                style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearSelector(BuildContext context, ChartState state) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: state.years.length + 1,
        cacheExtent: 40,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == state.years.length) {
            return GestureDetector(
              onTap: () => context.read<ChartBloc>().add(const LoadMoreYears()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chevron_left, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Xem thêm',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }

          final actualIndex = state.years.length - 1 - index;
          final year = state.years[actualIndex];
          final isSelected = actualIndex == state.selectedYearIndex;

          return GestureDetector(
            onTap: () {
              context.read<ChartBloc>().add(SelectYear(actualIndex));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: isSelected ? Colors.black : Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
              child: Text(
                _formatYearLabel(year),
                style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChart(BuildContext context, ChartState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.chartData.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('Không có dữ liệu để hiển thị', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.errorMessage!, style: const TextStyle(fontSize: 16, color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => context.read<ChartBloc>().add(const RefreshChart()), child: const Text('Thử lại')),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Chart
          Row(
            children: [
              AppChart(data: state.chartData, size: 150, strokeWidth: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.chartData
                      .map(
                        (data) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(color: data.color, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text('${data.label} ${data.value.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 14))),
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

          // Detailed list
          Expanded(
            child: ListView.separated(
              itemCount: state.chartData.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final data = state.chartData[index];
                final catId = state.chartCategoryIds.elementAt(index);
                final category = state.categoriesMap[catId];
                final gradientHex = state.categoryGradients[catId] ?? const <String>[];
                return Row(
                  children: [
                    // Icon with gradient background from transactions
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, gradient: gradientHex.isNotEmpty ? GradientHelper.fromColorHexList(gradientHex) : null, color: gradientHex.isEmpty ? data.color.withOpacity(0.2) : null),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgConstants.icon(assetPath: category?.pathAsset ?? Assets.svgsNote, size: SvgSizeType.medium),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Name + percentage + progress
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text('${data.label} ${data.value.toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(value: data.value / 100, backgroundColor: Colors.grey.shade200, color: data.color, minHeight: 6),
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
    );
  }

  void _showTransactionTypeDropdown(BuildContext context) {
    final options = TransactionType.values.map((t) => t.displayName).toList();

    AppDropdown.show<String>(
      context: context,
      targetKey: _dropdownKey,
      items: options,
      itemBuilder: (item) => Padding(
        padding: const EdgeInsets.all(12),
        child: Text(item, style: const TextStyle(color: Colors.black)),
      ),
      onItemSelected: (value) {
        final selectedType = TransactionType.values.firstWhere((t) => t.displayName == value, orElse: () => TransactionType.expense);
        context.read<ChartBloc>().add(ChangeTransactionType(selectedType));
      },
    );
  }

  String _formatMonthLabel(DateTime month) {
    final now = DateTime.now();
    if (month.year == now.year && month.month == now.month) {
      return 'Tháng này';
    }
    return 'T${month.month}/${month.year}';
  }

  String _formatYearLabel(int year) {
    final now = DateTime.now();
    if (year == now.year) {
      return 'Năm nay';
    }
    return 'Năm $year';
  }
}
