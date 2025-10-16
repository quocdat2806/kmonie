import 'package:flutter/material.dart';

import 'package:kmonie/core/cache/cache.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/entities/entities.dart';

class TransactionCategoryItem extends StatelessWidget {
  final TransactionCategory category;
  final bool isSelected;
  final double itemWidth;
  final VoidCallback onTap;

  const TransactionCategoryItem({super.key, required this.category, required this.isSelected, required this.itemWidth, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isSelected ? AppColorConstants.primary : AppColorConstants.greyWhite;
    final iconSize = itemWidth * AppUIConstants.categoryIconSizeRatio;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: itemWidth * AppUIConstants.categoryItemSizeRatio,
            height: itemWidth * AppUIConstants.categoryItemSizeRatio,
            child: DecoratedBox(
              decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
              child: Center(child: SvgCacheManager().getSvg(category.pathAsset, iconSize, iconSize)),
            ),
          ),
          const SizedBox(height: AppUIConstants.smallSpacing),
          Flexible(
            child: Text(category.title, textAlign: TextAlign.center, style: AppTextStyle.blackS12Medium, maxLines: AppUIConstants.defaultMaxLines, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
