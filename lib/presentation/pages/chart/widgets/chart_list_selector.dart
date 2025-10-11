import 'package:flutter/material.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';

class ChartListSelector extends StatelessWidget {
  final int itemCount;
  final int selectedIndex;
  final String Function(int actualIndex) labelBuilder;
  final VoidCallback onLoadMore;
  final void Function(int actualIndex) onSelect;

  const ChartListSelector({
    super.key,
    required this.itemCount,
    required this.selectedIndex,
    required this.labelBuilder,
    required this.onLoadMore,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppUIConstants.chartSelectorHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: itemCount + 1,
        cacheExtent: AppUIConstants.chartSelectorHeight,
        separatorBuilder: (_, _) =>
            const SizedBox(width: AppUIConstants.smallSpacing),
        itemBuilder: (context, index) {
          if (index == itemCount) {
            return InkWell(
              onTap: onLoadMore,
              child: const Icon(
                Icons.chevron_left,
                color: AppColorConstants.black,
                size: AppUIConstants.mediumIconSize,
              ),
            );
          }

          final actualIndex = itemCount - 1 - index;
          final isSelected = actualIndex == selectedIndex;

          return InkWell(
            onTap: () => onSelect(actualIndex),
            child: Container(
              decoration: BoxDecoration(
                border: isSelected
                    ? const Border(
                        bottom: BorderSide(
                          color: AppColorConstants.primary,
                          width: 2,
                        ),
                      )
                    : null,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppUIConstants.chartSelectorPadding,
                vertical: AppUIConstants.smallPadding,
              ),
              child: Text(
                labelBuilder(actualIndex),
                style: isSelected
                    ? AppTextStyle.blackS14Medium
                    : AppTextStyle.greyS14Medium,
              ),
            ),
          );
        },
      ),
    );
  }
}
