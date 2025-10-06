import 'package:flutter/material.dart';

import '../../../../core/cache/export.dart';
import '../../../../core/constant/export.dart';
import '../../../../core/text_style/export.dart';
import '../../../../entity/export.dart';

class TransactionCategoryItem extends StatelessWidget {
  final TransactionCategory category;
  final bool isSelected;
  final double itemWidth;
  final VoidCallback onTap;

  const TransactionCategoryItem({super.key, required this.category, required this.isSelected, required this.itemWidth, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isSelected ? ColorConstants.primary : ColorConstants.greyWhite;
    final iconSize = itemWidth * UIConstants.categoryIconSizeRatio;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: itemWidth * UIConstants.categoryItemSizeRatio,
            height: itemWidth * UIConstants.categoryItemSizeRatio,
            child: DecoratedBox(
              decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
              child: Center(child: SvgCacheManager().getSvg(category.pathAsset, iconSize, iconSize)),
            ),
          ),
          const SizedBox(height: UIConstants.smallSpacing),
          Flexible(
            child: Text(category.title, textAlign: TextAlign.center, style: AppTextStyle.blackS12Medium, maxLines: UIConstants.defaultMaxLines, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
