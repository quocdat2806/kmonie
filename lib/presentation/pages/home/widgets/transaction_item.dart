import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/constant/exports.dart';
import '../../../../core/text_style/export.dart';
import '../../../../generated/assets.dart';
import '../../../../entity/exports.dart';
import '../../../../core/enum/exports.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final TransactionCategory? category;

  const TransactionItem({super.key, required this.transaction, this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: UIConstants.smallPadding,
        vertical: UIConstants.smallPadding / 2,
      ),
      padding: const EdgeInsets.all(UIConstants.smallPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: UIConstants.largeIconSize,
            height: UIConstants.largeIconSize,
            decoration: BoxDecoration(
              color: _getCategoryColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                UIConstants.smallBorderRadius,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                _getCategoryIcon(),
                width: UIConstants.defaultIconSize,
                height: UIConstants.defaultIconSize,
                colorFilter: ColorFilter.mode(
                  _getCategoryColor(),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: UIConstants.smallPadding),

          // Content
          // Expanded(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         category?.title ?? 'Đang tải...',
          //         style: AppTextStyle.blackS14Bold,
          //       ),
          //       if (transaction.content.isNotEmpty) ...[
          //         const SizedBox(height: 2),
          //         Text(
          //           transaction.content,
          //           style: AppTextStyle.greyS12,
          //           maxLines: 1,
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //       ],
          //       const SizedBox(height: 2),
          //       Text(
          //         _formatTime(transaction.date),
          //         style: AppTextStyle.greyS12,
          //       ),
          //     ],
          //   ),
          // ),

          // Amount
          Text(
            _formatAmount(transaction.amount),
            style: AppTextStyle.blackS16Bold.copyWith(color: _getAmountColor()),
          ),
        ],
      ),
    );
  }

  String _getCategoryIcon() {
    return category?.pathAsset.isNotEmpty == true
        ? category!.pathAsset
        : Assets.svgsNote;
  }

  Color _getCategoryColor() {
    if (category?.transactionType == TransactionType.income) {
      return ColorConstants.secondary;
    }
    return ColorConstants.primary;
  }

  Color _getAmountColor() {
    if (category?.transactionType == TransactionType.income) {
      return ColorConstants.secondary;
    }
    return ColorConstants.primary;
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    );
    return '${formatter.format(amount)}đ';
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
