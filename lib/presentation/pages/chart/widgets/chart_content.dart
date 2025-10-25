import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/presentation/blocs/chart/chart.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class ChartContent extends StatelessWidget {
  const ChartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      buildWhen: (previous, current) => previous.chartData.length != current.chartData.length,
      builder: (context, state) {
        if (state.chartData.isEmpty) {
          return Center(child: Text(AppTextConstants.noData, style: AppTextStyle.greyS14));
        }
        return Padding(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          child: Column(
            children: [
              _buildChartSection(context, state.chartData),
              const SizedBox(height: AppUIConstants.defaultSpacing),
              _buildDetailedList(state.chartData),
              const SizedBox(height: AppUIConstants.defaultSpacing),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartSection(BuildContext context, List<ChartData> chartData) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Row(
        children: [
          ChartCircular(data: chartData, size: AppUIConstants.chartPieSize, strokeWidth: AppUIConstants.chartPieStrokeWidth),
          const SizedBox(width: AppUIConstants.defaultSpacing),
          Expanded(
            child: ListView.builder(
              itemCount: chartData.length,
              itemBuilder: (context, index) {
                final data = chartData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppUIConstants.chartContentVerticalSpacing),
                  child: Row(
                    children: [
                      Container(
                        width: AppUIConstants.chartLegendDotSize,
                        height: AppUIConstants.chartLegendDotSize,
                        decoration: BoxDecoration(shape: BoxShape.circle, gradient: data.gradientColors != null && data.gradientColors!.isNotEmpty ? GradientHelper.fromColorHexList(data.gradientColors!) : null, color: data.gradientColors == null || data.gradientColors!.isEmpty ? data.color : null),
                      ),
                      const SizedBox(width: AppUIConstants.smallSpacing),
                      Expanded(
                        child: Text('${data.label} ${data.value.toStringAsFixed(1)}%', style: const TextStyle(fontSize: AppUIConstants.chartContentTextSize)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedList(List<ChartData> chartData) {
    return Expanded(
      child: ListView.separated(
        itemCount: chartData.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppUIConstants.defaultSpacing),
        itemBuilder: (context, index) {
          final data = chartData[index];
          return Row(
            children: [
              _buildCategoryIcon(data),
              const SizedBox(width: AppUIConstants.chartCategorySpacing),
              _buildCategoryInfo(data),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryIcon(ChartData data) {
    return Container(
      width: AppUIConstants.chartCategoryIconSize,
      height: AppUIConstants.chartCategoryIconSize,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: data.gradientColors != null && data.gradientColors!.isNotEmpty ? GradientHelper.fromColorHexList(data.gradientColors!) : null, color: data.gradientColors == null || data.gradientColors!.isEmpty ? data.color.withValues(alpha: 0.2) : null),
      child: Padding(
        padding: const EdgeInsets.all(AppUIConstants.smallPadding),
        child: data.category?.pathAsset != null && data.category!.pathAsset.isNotEmpty ? SvgUtils.icon(assetPath: data.category!.pathAsset, size: SvgSizeType.medium) : const SizedBox(),
      ),
    );
  }

  Widget _buildCategoryInfo(ChartData data) {
    return Expanded(
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
          const SizedBox(height: AppUIConstants.chartCategoryTextSpacing),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppUIConstants.chartCategoryProgressRadius),
            child: LinearProgressIndicator(value: data.value / 100, backgroundColor: AppColorConstants.greyWhite, color: data.color, minHeight: AppUIConstants.chartCategoryProgressHeight),
          ),
        ],
      ),
    );
  }
}
