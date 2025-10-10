import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/export.dart';
import '../../../../core/text_style/export.dart';
import '../../../../core/tool/export.dart';
import '../../../../core/constant/export.dart';
import '../../../../core/enum/export.dart';
import '../../../bloc/export.dart';
import '../../../widgets/export.dart';

class ChartContent extends StatelessWidget {
  const ChartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.chartData.isEmpty) {
          return Center(child: Text('Không có dữ liệu để hiển thị', style: AppTextStyle.greyS14));
        }

        return Padding(
          padding: const EdgeInsets.all(UIConstants.defaultPadding),
          child: Column(
            children: [
              _buildChartSection(state),
              const SizedBox(height: UIConstants.largeSpacing),
              _buildDetailedList(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartSection(ChartState state) {
    return Row(
      children: [
        AppChart(data: state.chartData, size: UIConstants.chartPieSize, strokeWidth: UIConstants.chartPieStrokeWidth),
        const SizedBox(width: UIConstants.smallSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: state.chartData
                .map(
                  (data) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: UIConstants.chartContentVerticalSpacing),
                    child: Row(
                      children: [
                        Container(
                          width: UIConstants.chartLegendDotSize,
                          height: UIConstants.chartLegendDotSize,
                          decoration: BoxDecoration(color: data.color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: UIConstants.smallSpacing),
                        Expanded(
                          child: Text('${data.label} ${data.value.toStringAsFixed(1)}%', style: const TextStyle(fontSize: UIConstants.chartContentTextSize)),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedList(ChartState state) {
    return Expanded(
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
              _buildCategoryIcon(category, gradientHex, data),
              const SizedBox(width: UIConstants.chartCategorySpacing),
              _buildCategoryInfo(data),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryIcon(dynamic category, List<String> gradientHex, dynamic data) {
    return Container(
      width: UIConstants.chartCategoryIconSize,
      height: UIConstants.chartCategoryIconSize,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: gradientHex.isNotEmpty ? GradientHelper.fromColorHexList(gradientHex) : null, color: gradientHex.isEmpty ? (data.color as Color).withOpacity(0.2) : null),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.smallPadding),
        child: SvgConstants.icon(assetPath: (category?.pathAsset as String?) ?? Assets.svgsNote, size: SvgSizeType.medium),
      ),
    );
  }

  Widget _buildCategoryInfo(dynamic data) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('${data.label} ${(data.value as double).toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.chartCategoryTextSpacing),
          ClipRRect(
            borderRadius: BorderRadius.circular(UIConstants.chartCategoryProgressRadius),
            child: LinearProgressIndicator(value: (data.value as double) / 100, backgroundColor: ColorConstants.greyWhite, color: data.color as Color, minHeight: UIConstants.chartCategoryProgressHeight),
          ),
        ],
      ),
    );
  }
}
