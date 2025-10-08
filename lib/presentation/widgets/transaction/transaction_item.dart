import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kmonie/lib.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final TransactionCategory? category;

  final VoidCallback? onEdit;

  final VoidCallback? onConfirmDelete;

  const TransactionItem({super.key, required this.transaction, this.category, this.onEdit, this.onConfirmDelete});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(transaction.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.4,
        children: [
          SlidableAction(
            onPressed: (_) {
              onEdit?.call();
            },
            backgroundColor: ColorConstants.orange,
            foregroundColor: ColorConstants.white,
            label: TextConstants.edit,
          ),
          SlidableAction(
            onPressed: (_) {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AppDeleteDialog(
                    onConfirm: () async {
                      onConfirmDelete?.call();
                      AppNavigator(context: context).pop();
                    },
                  );
                },
              );
            },
            backgroundColor: ColorConstants.red,
            foregroundColor: ColorConstants.white,
            label: TextConstants.delete,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: UIConstants.smallPadding),
        child: Row(
          spacing: UIConstants.smallSpacing,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: GradientHelper.fromColorHexList(transaction.gradientColors)),
              child: Padding(
                padding: const EdgeInsets.all(UIConstants.smallPadding),
                child: SvgConstants.icon(assetPath: category!.pathAsset, size: SvgSizeType.medium),
              ),
            ),
            Expanded(child: Text(transaction.content.isNotEmpty ? transaction.content : category!.title, style: AppTextStyle.blackS14)),
            Text(transaction.transactionType == TransactionType.expense.typeIndex ? '-${FormatUtils.formatAmount(transaction.amount)}' : FormatUtils.formatAmount(transaction.amount), style: AppTextStyle.blackS14),
            SizedBox(width: UIConstants.smallSpacing),
          ],
        ),
      ),
    );
  }
}
