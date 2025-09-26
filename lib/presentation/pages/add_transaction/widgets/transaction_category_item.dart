import 'package:flutter/material.dart';
import 'package:kmonie/core/constant/exports.dart';
import 'package:kmonie/entity/exports.dart';
import '../../../../core/enum/transaction_type.dart';
import '../../../../core/text_style/app_text_style.dart';


class TransactionCategoryItem extends StatelessWidget {
  final TransactionCategory category;
  final TransactionType transactionType;
  final bool isSelected;
  final double itemWidth;
  final VoidCallback onTap;

  const TransactionCategoryItem({
    super.key,
    required this.category,
    required this.transactionType,
    required this.isSelected,
    required this.itemWidth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isSelected
        ? ColorConstants.yellow
        : ColorConstants.grey.withAlpha(150);
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: itemWidth * 0.55,
            height: itemWidth * 0.55,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.category,
                size: itemWidth * 0.30,
                color: ColorConstants.black,
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
