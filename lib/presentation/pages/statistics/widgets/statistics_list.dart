import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/generated/assets.dart';
import 'package:kmonie/entity/entity.dart';
import 'package:kmonie/core/enums/enums.dart';

class StatisticsList extends StatelessWidget {
  final Map<String, List<Transaction>> groupedTransactions;
  final Map<int, TransactionCategory> categoriesMap;

  const StatisticsList({
    super.key,
    required this.groupedTransactions,
    required this.categoriesMap,
  });

  @override
  Widget build(BuildContext context) {
    if (groupedTransactions.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(AppUIConstants.smallPadding),
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppUIConstants.smallBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(child: Text('Không có giao dịch nào')),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppUIConstants.smallPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Chi tiết giao dịch', style: AppTextStyle.blackS16Bold),
          const SizedBox(height: AppUIConstants.smallPadding),
          ...groupedTransactions.entries.map((entry) {
            return _buildDateGroup(entry.key, entry.value);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDateGroup(String dateKey, List<Transaction> transactions) {
    final totalAmount = transactions.fold(0.0, (sum, t) => sum + t.amount);

    return Container(
      margin: const EdgeInsets.only(bottom: AppUIConstants.smallPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppUIConstants.smallBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Date header
          Container(
            padding: const EdgeInsets.all(AppUIConstants.smallPadding),
            decoration: BoxDecoration(
              color: AppColorConstants.grey.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppUIConstants.smallBorderRadius),
                topRight: Radius.circular(AppUIConstants.smallBorderRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateKey, style: AppTextStyle.blackS14Bold),
                Text(
                  _formatAmount(totalAmount.toInt()),
                  style: AppTextStyle.blackS14Bold.copyWith(
                    color: AppColorConstants.primary,
                  ),
                ),
              ],
            ),
          ),

          // Transaction items
          ...transactions.map((transaction) {
            return _buildTransactionItem(transaction);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final category = categoriesMap[transaction.transactionCategoryId];

    return Container(
      padding: const EdgeInsets.all(AppUIConstants.smallPadding),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColorConstants.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: AppUIConstants.largeIconSize,
            height: AppUIConstants.largeIconSize,
            decoration: BoxDecoration(
              color: _getCategoryColor(category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                AppUIConstants.smallBorderRadius,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                _getCategoryIcon(category),
                width: AppUIConstants.defaultIconSize,
                height: AppUIConstants.defaultIconSize,
                colorFilter: ColorFilter.mode(
                  _getCategoryColor(category),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppUIConstants.smallPadding),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category?.title ?? 'Đang tải...',
                  style: AppTextStyle.blackS14Bold,
                ),
                if (transaction.content.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    transaction.content,
                    style: AppTextStyle.greyS12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  _formatTime(transaction.date),
                  style: AppTextStyle.greyS12,
                ),
              ],
            ),
          ),

          // Amount
          Text(
            _formatAmount(transaction.amount),
            style: AppTextStyle.blackS16Bold.copyWith(
              color: _getCategoryColor(category),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryIcon(TransactionCategory? category) {
    return category?.pathAsset.isNotEmpty == true
        ? category!.pathAsset
        : Assets.svgsNote;
  }

  Color _getCategoryColor(TransactionCategory? category) {
    if (category?.transactionType == TransactionType.income) {
      return AppColorConstants.secondary;
    }
    return AppColorConstants.primary;
  }

  String _formatAmount(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}Mđ';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}Kđ';
    }
    return '${amount.toStringAsFixed(0)}đ';
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Hôm nay ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (transactionDate == today.subtract(const Duration(days: 1))) {
      return 'Hôm qua ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}
