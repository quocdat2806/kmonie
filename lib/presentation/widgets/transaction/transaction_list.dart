import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/args/args.dart';

class TransactionList extends StatelessWidget {
  final Map<String, List<Transaction>> groupedTransactions;
  final Map<int, TransactionCategory> categoriesMap;
  final Widget? emptyWidget;
  final Widget Function(String dateKey)? dailyTotalWidgetBuilder;

  final ScrollController? scrollController;

  const TransactionList({
    super.key,
    required this.groupedTransactions,
    required this.categoriesMap,
    this.emptyWidget,
    this.dailyTotalWidgetBuilder,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (groupedTransactions.isEmpty) {
      return emptyWidget ?? const SizedBox();
    }
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final dateKey = groupedTransactions.keys.elementAt(index);
            final transactions = groupedTransactions[dateKey]!;
            return Padding(
              padding: const EdgeInsets.all(AppUIConstants.smallPadding),
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
                  const SizedBox(height: AppUIConstants.smallSpacing),
                  const AppDivider(),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final category =
                          categoriesMap[transaction.transactionCategoryId];
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () => AppNavigator(context: context).push(
                          RouterPath.detailTransaction,
                          extra: DetailTransactionArgs(
                            transaction: transaction,
                            category: category!,
                          ),
                        ),
                        child: TransactionItem(
                          onConfirmDelete: () async {
                            await sl<TransactionRepository>().deleteTransaction(
                              transaction.id!,
                            );
                            AppStreamEvent.deleteTransactionStatic(
                              transaction.id!,
                            );
                          },
                          onEdit: () => AppNavigator(context: context).push(
                            RouterPath.transactionActions,
                            extra: TransactionActionsPageArgs(
                              mode: ActionsMode.edit,
                              transaction: transaction,
                            ),
                          ),
                          transaction: transaction,
                          category: category,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const AppDivider(),
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
