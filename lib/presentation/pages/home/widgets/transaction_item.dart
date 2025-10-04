import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/enum/export.dart';
import '../../../../core/util/export.dart';
import '../../../../core/constant/export.dart';
import '../../../../core/text_style/export.dart';
import '../../../../core/tool/export.dart';
import '../../../../entity/export.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final TransactionCategory? category;

  const TransactionItem({super.key, required this.transaction, this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UIConstants.smallPadding),
      child: Row(
        spacing: UIConstants.smallSpacing,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: GradientHelper.fromColorHexList(
                transaction.gradientColors,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(UIConstants.smallPadding),
              child: SvgPicture.asset(
                category!.pathAsset,
                width: UIConstants.largeIconSize,
                height: UIConstants.largeIconSize,
              ),
            ),
          ),
          Expanded(
            child: Text(
              transaction.content.isNotEmpty
                  ? transaction.content
                  : category!.title,
              style: AppTextStyle.blackS14,
            ),
          ),
          Text(
            transaction.transactionType==TransactionType.expense.typeIndex? '-${FormatUtils.formatAmount(transaction.amount.toDouble())}' :FormatUtils.formatAmount(transaction.amount.toDouble()),
            style: AppTextStyle.blackS14,
          ),
        ],
      ),
    );
  }
}
