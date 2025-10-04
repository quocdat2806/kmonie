import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/util/export.dart';
import '../../../bloc/export.dart';
import '../../../../core/text_style/export.dart';
import '../../../../entity/export.dart';
import 'transaction_item.dart';

class TransactionDateGroup extends StatelessWidget {
  final String dateKey;
  final List<Transaction> transactions;
  final Map<int, TransactionCategory> categoriesMap;

  const TransactionDateGroup({
    super.key,
    required this.dateKey,
    required this.transactions,
    required this.categoriesMap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dateKey, style: AppTextStyle.blackS16Bold),
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) =>
                  previous.groupedTransactions != current.groupedTransactions||
                  previous.categoriesMap != current.categoriesMap,
              builder: (context, state) {
                return (state.totalIncome > 0 || state.totalExpense > 0)
                    ? Text(
                        FormatUtils.formatTotalText(
                          state.totalIncome,
                          state.totalExpense,
                        ),
                        style: AppTextStyle.greyS12,
                      )
                    : SizedBox();
              },
            ),
          ],
        ),

        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final category = categoriesMap[transaction.transactionCategoryId];
            return TransactionItem(
              transaction: transaction,
              category: category,
            );
          },
        ),
      ],
    );
  }
}
