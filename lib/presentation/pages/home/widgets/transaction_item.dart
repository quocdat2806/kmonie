import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/exports.dart';
import '../../../../core/enum/exports.dart';
import '../../../../core/text_style/export.dart';
import '../../../../core/tool/gradient.dart';
import '../../../../entity/exports.dart';
import '../../../../generated/assets.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final TransactionCategory? category;

  const TransactionItem({super.key, required this.transaction, this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: UIConstants.smallPadding, vertical: UIConstants.smallPadding / 2),
      padding: const EdgeInsets.all(UIConstants.smallPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
        gradient: GradientHelper.fromColorHexList(transaction.gradientColors),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: UIConstants.largeIconSize,
            height: UIConstants.largeIconSize,
            decoration: BoxDecoration(color: _getCategoryColor().withOpacity(0.1), borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius)),
            child: Center(
              child: SvgPicture.asset(_getCategoryIcon(), width: UIConstants.defaultIconSize, height: UIConstants.defaultIconSize, colorFilter: ColorFilter.mode(_getCategoryColor(), BlendMode.srcIn)),
            ),
          ),
          const SizedBox(width: UIConstants.smallPadding),
          Text(transaction.amount.toString(), style: AppTextStyle.blackS16Bold.copyWith(color: _getAmountColor())),
        ],
      ),
    );
  }

  String _getCategoryIcon() {
    return category?.pathAsset.isNotEmpty == true ? category!.pathAsset : Assets.svgsNote;
  }

  Color _getCategoryColor() {
    if (category?.transactionType == TransactionType.income) {
      return ColorConstants.secondary;
    }
    return ColorConstants.primary;
  }

  Color _getAmountColor() {
    if (category?.transactionType == TransactionType.income) {
      return ColorConstants.secondary;
    }
    return ColorConstants.primary;
  }
}
