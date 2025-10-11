import 'dart:async';

import 'package:flutter/material.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entity/entity.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import '../transaction_action/transaction_actions_page.dart';

class DetailTransactionArgs {
  final Transaction transaction;
  final TransactionCategory category;

  DetailTransactionArgs({required this.transaction, required this.category});
}

class DetailTransactionPage extends StatefulWidget {
  final DetailTransactionArgs args;

  const DetailTransactionPage({super.key, required this.args});

  @override
  State<DetailTransactionPage> createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  late Transaction _transaction;
  late TransactionCategory _category;
  late StreamSubscription<AppStreamData> _sub;

  @override
  void initState() {
    super.initState();
    _transaction = widget.args.transaction;
    _category = widget.args.category;

    _sub = AppStreamEvent.eventStreamStatic.listen((event) {
      if (event.event == AppEvent.updateTransaction) {
        final updatedTx = event.payload as Transaction;
        if (updatedTx.id == _transaction.id) {
          setState(() {
            _transaction = updatedTx;
          });
        }
      }

      if (event.event == AppEvent.deleteTransaction &&
          event.payload == _transaction.id) {
        if (mounted) Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String typeLabel = _category.transactionType.displayName;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Chi tiết giao dịch'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(_category, _transaction),
              const SizedBox(height: AppUIConstants.defaultSpacing),
              _buildRow('Kiểu', typeLabel),
              _buildRow(
                'Số tiền',
                FormatUtils.formatCurrency(_transaction.amount),
              ),
              _buildDateRow('Ngày', _transaction.date),
              _buildRow(
                'Ghi chú',
                _transaction.content.isEmpty ? '(Trống)' : _transaction.content,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: AppUIConstants.defaultButtonHeight,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColorConstants.greyWhite)),
            color: AppColorConstants.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  text: AppTextConstants.edit,
                  backgroundColor: Colors.transparent,
                  onPressed: _onEditPressed,
                ),
              ),
              Container(width: 1, color: AppColorConstants.greyWhite),
              Expanded(
                child: AppButton(
                  backgroundColor: Colors.transparent,
                  onPressed: _onDeletePressed,
                  text: AppTextConstants.delete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEditPressed() {
    AppNavigator(context: context).push(
      RouterPath.transactionActions,
      extra: TransactionActionsPageArgs(
        mode: TransactionActionsMode.edit,
        transaction: _transaction,
      ),
    );
  }

  void _onDeletePressed() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AppDeleteDialog(
          onConfirm: () async {
            Navigator.of(context).pop();
            AppStreamEvent.deleteTransactionStatic(_transaction.id!);
          },
        );
      },
    );
  }

  Widget _buildHeader(TransactionCategory category, Transaction transaction) {
    return Row(
      spacing: AppUIConstants.defaultSpacing,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: GradientHelper.fromColorHexList(
              transaction.gradientColors,
            ),
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

  Widget _buildDateRow(String label, DateTime date) {
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
                '(Thêm ${AppDateUtils.formatFullDate(date)})',
                style: AppTextStyle.greyS12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
