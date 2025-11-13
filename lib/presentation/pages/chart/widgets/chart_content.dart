import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/args/args.dart';

class ChartContent extends StatelessWidget {
  const ChartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      buildWhen: (previous, current) =>
          previous.chartData.length != current.chartData.length,
      builder: (context, state) {
        if (state.chartData.isEmpty) {
          return Center(
            child: Text(AppTextConstants.noData, style: AppTextStyle.greyS14),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          child: Column(
            children: [
              _buildChartSection(context, state.chartData),
              _buildDetailedList(state.chartData),
              const SizedBox(height: AppUIConstants.defaultSpacing),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartSection(BuildContext context, List<ChartDataArgs> chartData) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Row(
        children: [
          ChartCircular(data: chartData),
          const SizedBox(width: AppUIConstants.smallSpacing),
          Expanded(
            child: ListView.builder(
              itemCount: chartData.length,
              itemBuilder: (context, index) {
                final data = chartData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppUIConstants.smallPadding,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: AppUIConstants.superSmallContainerSize,
                        height: AppUIConstants.superSmallContainerSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: GradientHelper.fromColorHexList(
                            data.gradientColors!,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppUIConstants.smallSpacing),
                      Expanded(
                        child: Text(
                          '${data.label} ${data.value.toStringAsFixed(1)}%',
                          style: AppTextStyle.blackS14Medium,
                        ),
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

  Widget _buildDetailedList(List<ChartDataArgs> chartData) {
    return Expanded(
      child: ListView.separated(
        itemCount: chartData.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: AppUIConstants.smallSpacing),
        itemBuilder: (context, index) {
          final data = chartData[index];
          return Row(
            spacing: AppUIConstants.smallSpacing,
            children: [_buildCategoryIcon(data), _buildCategoryInfo(data)],
          );
        },
      ),
    );
  }

  Widget _buildCategoryIcon(ChartDataArgs data) {
    return Container(
      width: AppUIConstants.mediumContainerSize,
      height: AppUIConstants.mediumContainerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: GradientHelper.fromColorHexList(data.gradientColors!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppUIConstants.smallPadding),
        child: SvgUtils.icon(assetPath: data.category!.pathAsset),
      ),
    );
  }

  Widget _buildCategoryInfo(ChartDataArgs data) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${data.label} ${data.value.toStringAsFixed(1)}%',
            style: AppTextStyle.blackS14Medium,
          ),
          const SizedBox(height: AppUIConstants.smallSpacing),

          ClipRRect(
            borderRadius: BorderRadius.circular(
              AppUIConstants.defaultBorderRadius,
            ),
            child: LinearProgressIndicator(
              value: data.value / 100,
              backgroundColor: AppColorConstants.greyWhite,
              color: data.color,
              minHeight: AppUIConstants.superSmallHeight,
            ),
          ),
        ],
      ),
    );
  }
}
