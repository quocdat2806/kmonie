import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/args/args.dart';

class DetailTransactionPage extends StatelessWidget {
  final DetailTransactionArgs args;

  const DetailTransactionPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final Transaction transaction = args.transaction;
    final TransactionCategory category = args.category;
    final String typeLabel = category.transactionType.displayName;
    return Scaffold(
      appBar: const CustomAppBar(title: AppTextConstants.detailTransaction),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderTransaction(category, transaction),
              _buildRow(AppTextConstants.type, typeLabel),
              _buildRow(
                AppTextConstants.amount,
                FormatUtils.formatCurrency(transaction.amount),
              ),
              _buildDateRow(
                AppTextConstants.date,
                transaction.date,
                transaction.createdAt,
              ),
              _buildRow(
                AppTextConstants.note,
                transaction.content.isEmpty
                    ? AppTextConstants.empty
                    : transaction.content,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTransaction(
    TransactionCategory category,
    Transaction transaction,
  ) {
    return Row(
      spacing: AppUIConstants.defaultSpacing,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: GradientHelper.fromColorHexList(category.gradientColors),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppUIConstants.smallPadding),
            child: SvgUtils.icon(
              assetPath: category.pathAsset,
              size: SvgSizeType.medium,
            ),
          ),
        ),
        Expanded(
          child: Text(
            category.title,
            style: AppTextStyle.blackS16Medium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppUIConstants.smallPadding,
      ),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: AppTextStyle.greyS14)),
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.blackS14Medium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime date, DateTime? createdAt) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppUIConstants.smallPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: AppTextStyle.greyS14)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppUIConstants.smallSpacing,
            children: [
              Text(
                AppDateUtils.formatDate(date),
                style: AppTextStyle.blackS14Medium,
              ),
              Text(
                '(${AppTextConstants.add} ${AppDateUtils.formatFullDate(createdAt ?? date)})',
                style: AppTextStyle.greyS12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
