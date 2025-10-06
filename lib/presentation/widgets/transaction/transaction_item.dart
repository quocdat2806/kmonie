
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmonie/lib.dart';
import 'package:kmonie/presentation/widgets/dialog/detele_dialog/app_delete_dialog.dart';

import '../../../core/constant/export.dart';
import '../../../core/enum/export.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../core/navigation/router_path.dart';
import '../../../core/text_style/export.dart';
import '../../../core/tool/export.dart';
import '../../../core/util/export.dart';
import '../../../entity/export.dart';
import '../../pages/transaction_action/transaction_actions_page.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final TransactionCategory? category;

  final VoidCallback? onEdit;

  final VoidCallback? onDelete;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.category,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(transaction.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (_){
              onEdit?.call();
            },
            backgroundColor:ColorConstants.orange,
            foregroundColor:ColorConstants.white,
            label: 'Sửa',
          ),
          SlidableAction(
            onPressed: (_) {
               showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return  AppDeleteDialog(
                    onConfirm: ()async{
                      onDelete?.call();
                      AppNavigator(context: context).pop();
                    },
                  );
                },
              );
            },
            backgroundColor: ColorConstants.red,
            foregroundColor: ColorConstants.white,
            label: 'Xóa',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: UIConstants.smallPadding),
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
                  width: UIConstants.mediumIconSize,
                  height: UIConstants.mediumIconSize,
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
              transaction.transactionType == TransactionType.expense.typeIndex
                  ? '-${FormatUtils.formatAmount(transaction.amount.toDouble())}'
                  : FormatUtils.formatAmount(transaction.amount.toDouble()),
              style: AppTextStyle.blackS14,
            ),
            SizedBox(width: UIConstants.smallPadding)
          ],
        ),
      ),
    );
  }
}
