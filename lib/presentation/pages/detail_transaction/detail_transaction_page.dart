import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constant/export.dart';
import '../../../core/enum/export.dart';
import '../../../core/navigation/export.dart';
import '../../../core/stream/export.dart';
import '../../../core/text_style/export.dart';
import '../../../core/tool/export.dart';
import '../../../core/util/export.dart';
import '../../../entity/export.dart';
import '../../widgets/export.dart';
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

      if (event.event == AppEvent.deleteTransaction && event.payload == _transaction.id) {
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
      appBar: const CustomAppBar(title: 'Chi tiết giao dịch', centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(_category, _transaction),
              const SizedBox(height: UIConstants.defaultSpacing),
              _buildRow('Kiểu', typeLabel),
              _buildRow('Số tiền', FormatUtils.formatAmount(_transaction.amount)),
              _buildDateRow('Ngày', _transaction.date.toLocal()),
              _buildRow('Ghi chú', _transaction.content.isEmpty ? '(Trống)' : _transaction.content),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: AppButton(text: TextConstants.edit, backgroundColor: Colors.transparent, onPressed: _onEditPressed),
              ),
              Container(width: 1, color: Colors.grey.shade300),
              Expanded(
                child: AppButton(backgroundColor: Colors.transparent, onPressed: _onDeletePressed, text: TextConstants.delete, height: 56),
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
      extra: TransactionActionsPageArgs(mode: TransactionActionsMode.edit, transaction: _transaction),
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
      children: [
        DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: GradientHelper.fromColorHexList(transaction.gradientColors)),
          child: Padding(
            padding: const EdgeInsets.all(UIConstants.smallPadding),
            child: SvgConstants.icon(assetPath: category.pathAsset, size: SvgSizeType.medium),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(category.title, style: AppTextStyle.blackS16Medium, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UIConstants.smallPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 80, child: Text(label, style: AppTextStyle.greyS14)),
          Expanded(
            child: Text(value, style: AppTextStyle.blackS14Medium, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: AppTextStyle.greyS14)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: UIConstants.smallSpacing,
            children: [
              Text(AppDateUtils.formatDate(date), style: AppTextStyle.blackS14Medium),
              Text('(Thêm ${AppDateUtils.formatFullDate(date)})', style: AppTextStyle.greyS12),
            ],
          ),
        ],
      ),
    );
  }
}
