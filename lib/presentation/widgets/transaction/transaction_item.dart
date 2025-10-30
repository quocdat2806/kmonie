import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/widgets/dialog/dialogs.dart';

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
            backgroundColor: AppColorConstants.orange,
            foregroundColor: AppColorConstants.white,
            label: AppTextConstants.edit,
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
            backgroundColor: AppColorConstants.red,
            foregroundColor: AppColorConstants.white,
            label: AppTextConstants.delete,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppUIConstants.smallPadding),
        child: Row(
          spacing: AppUIConstants.smallSpacing,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: GradientHelper.fromColorHexList(category!.gradientColors)),
              child: Padding(
                padding: const EdgeInsets.all(AppUIConstants.smallPadding),
                child: SvgUtils.icon(assetPath: category!.pathAsset, size: SvgSizeType.medium),
              ),
            ),
            Expanded(child: Text(transaction.content.isNotEmpty ? transaction.content : category!.title, style: AppTextStyle.blackS14)),
            Text(transaction.transactionType == TransactionType.expense.typeIndex ? '-${FormatUtils.formatCurrency(transaction.amount)}' : FormatUtils.formatCurrency(transaction.amount), style: AppTextStyle.blackS14),
          ],
        ),
      ),
    );
  }
}
