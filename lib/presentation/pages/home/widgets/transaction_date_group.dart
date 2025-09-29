import 'package:flutter/material.dart';
import '../../../../core/constant/exports.dart';
import '../../../../core/text_style/export.dart';
import '../../../../core/enum/exports.dart';
import '../../../../entity/exports.dart';
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
    final totalIncome = _calculateTotalIncome();
    final totalExpense = _calculateTotalExpense();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: UIConstants.smallPadding,
            vertical: UIConstants.smallPadding / 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateKey, style: AppTextStyle.blackS16Bold),
              if (totalIncome > 0 || totalExpense > 0)
                Text(
                  _formatTotalText(totalIncome, totalExpense),
                  style: AppTextStyle.greyS12,
                ),
            ],
          ),
        ),

        // Transaction items
        ...transactions.map((transaction) {
          final category = categoriesMap[transaction.transactionCategoryId];
          return TransactionItem(transaction: transaction, category: category);
        }).toList(),
      ],
    );
  }

  double _calculateTotalIncome() {
    return transactions
        .where((t) {
          final category = categoriesMap[t.transactionCategoryId];
          return category?.transactionType == TransactionType.income;
        })
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateTotalExpense() {
    return transactions
        .where((t) {
          final category = categoriesMap[t.transactionCategoryId];
          return category?.transactionType == TransactionType.expense;
        })
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  String _formatTotalText(double income, double expense) {
    if (income > 0 && expense > 0) {
      return 'Thu: ${_formatAmount(income)} | Chi: ${_formatAmount(expense)}';
    } else if (income > 0) {
      return 'Thu: ${_formatAmount(income)}';
    } else if (expense > 0) {
      return 'Chi: ${_formatAmount(expense)}';
    }
    return '';
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
