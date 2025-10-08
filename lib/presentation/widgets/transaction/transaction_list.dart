import 'package:flutter/material.dart';

import '../../../core/constant/export.dart';
import '../../../core/enum/export.dart';
import '../../../core/navigation/export.dart';
import '../../../core/stream/export.dart';
import '../../../core/text_style/export.dart';
import '../../../entity/export.dart';
import '../../pages/export.dart';
import '../divider/app_divider.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final Map<String, List<Transaction>> groupedTransactions;
  final Map<int, TransactionCategory> categoriesMap;
  final Widget? emptyWidget;
  final Widget Function(String dateKey)? dailyTotalWidgetBuilder;

  const TransactionList({
    super.key,
    required this.groupedTransactions,
    required this.categoriesMap,
    this.emptyWidget,
    this.dailyTotalWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (groupedTransactions.isEmpty) {
      return emptyWidget ?? SizedBox();
    }
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final dateKey = groupedTransactions.keys.elementAt(index);
            final transactions = groupedTransactions[dateKey]!;
            return Padding(
              padding: const EdgeInsets.all(UIConstants.smallPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dateKey, style: AppTextStyle.blackS12),
                      if (dailyTotalWidgetBuilder != null)
                        dailyTotalWidgetBuilder!(dateKey),
                    ],
                  ),
                  SizedBox(height: UIConstants.smallSpacing),
                  AppDivider(),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final category =
                          categoriesMap[transaction.transactionCategoryId];
                      return InkWell(
                        onTap: () => AppNavigator(context: context).push(
                          RouterPath.detailTransaction,
                          extra: DetailTransactionArgs(
                            transaction: transaction,
                            category: category!,
                          ),
                        ),
                        child: TransactionItem(
                          onConfirmDelete: () =>
                              AppStreamEvent.deleteTransactionStatic(
                                transaction.id!,
                              ),
                          onEdit: () => AppNavigator(context: context).push(
                            RouterPath.transactionActions,
                            extra: TransactionActionsPageArgs(
                              mode: TransactionActionsMode.edit,
                              transaction: transaction,
                            ),
                          ),
                          transaction: transaction,
                          category: category,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => AppDivider(),
                  ),
                ],
              ),
            );
          }, childCount: groupedTransactions.length),
        ),
      ],
    );
  }
}
