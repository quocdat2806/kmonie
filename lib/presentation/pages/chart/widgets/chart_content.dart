import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/presentation/bloc/chart/chart_export.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/entities/entities.dart';

class ChartContent extends StatelessWidget {
  const ChartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      buildWhen: (previous, current) => previous.chartData.length != current.chartData.length,
      builder: (context, state) {
        if (state.chartData.isEmpty) {
          return Center(child: Text('Không có dữ liệu để hiển thị', style: AppTextStyle.greyS14));
        }

        return Padding(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          child: Column(
            children: [
              _buildChartSection(state),
              const SizedBox(height: AppUIConstants.largeSpacing),
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
        ChartCircular(data: state.chartData, size: AppUIConstants.chartPieSize, strokeWidth: AppUIConstants.chartPieStrokeWidth),
        const SizedBox(width: AppUIConstants.smallSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: state.chartData
                .map(
                  (data) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppUIConstants.chartContentVerticalSpacing),
                    child: Row(
                      children: [
                        Container(
                          width: AppUIConstants.chartLegendDotSize,
                          height: AppUIConstants.chartLegendDotSize,
                          decoration: BoxDecoration(color: data.color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: AppUIConstants.smallSpacing),
                        Expanded(
                          child: Text('${data.label} ${data.value.toStringAsFixed(1)}%', style: const TextStyle(fontSize: AppUIConstants.chartContentTextSize)),
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
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: (context, index) {
          final data = state.chartData[index];
          final catId = state.chartCategoryIds.elementAt(index);
          final category = state.categoriesMap[catId];
          final gradientHex = state.categoryGradients[catId] ?? const <String>[];

          return Row(
            children: [
              _buildCategoryIcon(category as TransactionCategory, gradientHex, data),
              const SizedBox(width: AppUIConstants.chartCategorySpacing),
              _buildCategoryInfo(data),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryIcon(TransactionCategory category, List<String> gradientHex, ChartData data) {
    return Container(
      width: AppUIConstants.chartCategoryIconSize,
      height: AppUIConstants.chartCategoryIconSize,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: gradientHex.isNotEmpty ? GradientHelper.fromColorHexList(gradientHex) : null, color: gradientHex.isEmpty ? (data.color).withValues(alpha: 0.2) : null),
      child: Padding(
        padding: const EdgeInsets.all(AppUIConstants.smallPadding),
        child: SvgUtils.icon(assetPath: category.pathAsset.isNotEmpty ? category.pathAsset : Assets.svgsNote, size: SvgSizeType.medium),
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
