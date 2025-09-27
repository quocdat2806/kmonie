import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kmonie/core/constant/exports.dart';
import 'package:kmonie/entity/exports.dart';
import '../../../../core/cache/cache.dart';
import '../../../../core/enum/transaction_type.dart';
import '../../../../core/text_style/app_text_style.dart';

class TransactionCategoryItem extends StatelessWidget {
  static final Map<String, Widget> _svgCache = {};
  final TransactionCategory category;
  final bool isSelected;
  final double itemWidth;
  final VoidCallback onTap;

  const TransactionCategoryItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.itemWidth,
    required this.onTap,
  });

  Widget _buildSvgIcon() {
    return _svgCache[category.pathAsset] ??= SvgPicture.asset(
      category.pathAsset,
      width: itemWidth * UIConstants.categoryIconSizeRatio,
      height: itemWidth *UIConstants.categoryIconSizeRatio,
    );
  }
  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isSelected
        ? ColorConstants.primary
        : ColorConstants.iconBackground;
    final iconSize = itemWidth * UIConstants.categoryIconSizeRatio;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: itemWidth * UIConstants.categoryItemSizeRatio,
            height: itemWidth * UIConstants.categoryItemSizeRatio,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgCacheManager().getSvg(
                  category.pathAsset,
                  iconSize,
                  iconSize,
                ),
              ),
            ),
          ),
          const SizedBox(height: UIConstants.smallSpacing),
          Flexible(
            child: Text(
              category.title,
              textAlign: TextAlign.center,
              style: AppTextStyle.blackS12Medium,
              maxLines: UIConstants.defaultMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
