import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/export.dart';
import '../../../../core/text_style/export.dart';
import '../../../../core/util/export.dart';
import '../../../../entity/export.dart';
import '../../../bloc/export.dart';
import '../../../widgets/export.dart';
import 'transaction_item.dart';

class TransactionDateGroup extends StatelessWidget {
  final String dateKey;
  final List<Transaction> transactions;
  final Map<int, TransactionCategory> categoriesMap;

  const TransactionDateGroup({super.key, required this.dateKey, required this.transactions, required this.categoriesMap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UIConstants.smallPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateKey, style: AppTextStyle.blackS12),
              BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) => previous.groupedTransactions != current.groupedTransactions || previous.categoriesMap != current.categoriesMap,
                builder: (context, state) {
                  return (state.calculateTotalExpense > 0 || state.calculateTotalIncome > 0) ? Text(FormatUtils.formatTotalText(state.calculateTotalExpense, state.calculateTotalIncome), style: AppTextStyle.blackS12) : SizedBox();
                },
              ),
            ],
          ),
          SizedBox(height: UIConstants.smallPadding),
          AppDivider(),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final category = categoriesMap[transaction.transactionCategoryId];
              return TransactionItem(transaction: transaction, category: category);
            },
            separatorBuilder: (context, index) => AppDivider(),
          ),
        ],
      ),
    );
  }
}
