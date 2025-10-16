import 'dart:async';
import 'package:flutter/material.dart';

import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/utils/date.dart';
import 'package:kmonie/core/utils/format.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class DailyTransactionPageArgs {
  final DateTime selectedDate;
  final Map<String, List<Transaction>> groupedTransactions;
  final Map<int, TransactionCategory> categoriesMap;

  const DailyTransactionPageArgs({required this.selectedDate, required this.groupedTransactions, required this.categoriesMap});
}

class DailyTransactionPage extends StatefulWidget {
  final DailyTransactionPageArgs args;

  const DailyTransactionPage({super.key, required this.args});

  @override
  State<DailyTransactionPage> createState() => _DailyTransactionPageState();
}

class _DailyTransactionPageState extends State<DailyTransactionPage> {
  late Map<String, List<Transaction>> _groupedTransactions;
  late Map<int, TransactionCategory> _categoriesMap;
  StreamSubscription<AppStreamData>? _streamSub;

  @override
  void initState() {
    super.initState();
    _groupedTransactions = Map.of(widget.args.groupedTransactions);
    _categoriesMap = Map.of(widget.args.categoriesMap);

    _streamSub = AppStreamEvent.eventStreamStatic.listen((data) {
      if (data.event == AppEvent.insertTransaction) {
        _handleInsert(data.payload as Transaction);
      }
      if (data.event == AppEvent.updateTransaction) {
        _handleUpdate(data.payload as Transaction);
      }
      if (data.event == AppEvent.deleteTransaction) {
        _handleDelete(data.payload as int);
      }
    });
  }

  void _handleInsert(Transaction tx) {
    if (!_isSameDate(tx.date, widget.args.selectedDate)) return;
    final dateKey = AppDateUtils.formatDateKey(tx.date);
    setState(() {
      final list = _groupedTransactions[dateKey] ?? [];
      if (!list.any((e) => e.id == tx.id)) {
        list.insert(0, tx);
        _groupedTransactions[dateKey] = list;
      }
    });
  }

  void _handleUpdate(Transaction tx) {
    final isSameDay = _isSameDate(tx.date, widget.args.selectedDate);

    if (!isSameDay) {
      setState(() {
        for (final key in _groupedTransactions.keys) {
          final list = _groupedTransactions[key]!;
          _groupedTransactions[key] = list.where((e) => e.id != tx.id).toList();
        }
        _groupedTransactions.removeWhere((_, list) => list.isEmpty);
      });
      return;
    }

    final key = AppDateUtils.formatDateKey(tx.date);
    setState(() {
      final list = _groupedTransactions[key];
      if (list == null) return;
      final index = list.indexWhere((e) => e.id == tx.id);
      if (index != -1) {
        list[index] = tx;
        _groupedTransactions[key] = List.of(list);
      }
    });
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _handleDelete(int id) {
    setState(() {
      for (final key in _groupedTransactions.keys) {
        final list = _groupedTransactions[key]!;
        final newList = list.where((e) => e.id != id).toList();
        _groupedTransactions[key] = newList;
      }
      _groupedTransactions.removeWhere((_, list) => list.isEmpty);
    });
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
  }

  Widget Function(String dateKey) _buildDailyTotalBuilder() {
    return (String dateKey) {
      final transactions = _groupedTransactions[dateKey] ?? [];
      if (transactions.isEmpty) return const SizedBox();

      int income = 0;
      int expense = 0;
      int transfer = 0;

      for (final transaction in transactions) {
        switch (TransactionType.fromIndex(transaction.transactionType)) {
          case TransactionType.income:
            income += transaction.amount;
            break;
          case TransactionType.expense:
            expense += transaction.amount;
            break;
          case TransactionType.transfer:
            transfer += transaction.amount;
            break;
        }
      }

      return Text(FormatUtils.formatDailyTransactionTotal(income.toDouble(), expense.toDouble(), transfer.toDouble()), style: AppTextStyle.blackS12);
    };
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = AppDateUtils.formatDate(widget.args.selectedDate);

    final bool isEmpty = _groupedTransactions.isEmpty || _groupedTransactions.values.every((list) => list.isEmpty);

    return Scaffold(
      appBar: CustomAppBar(title: 'Giao dịch $dateStr'),
      body: SafeArea(
        child: isEmpty ? _buildEmptyState(context) : TransactionList(groupedTransactions: _groupedTransactions, categoriesMap: _categoriesMap, dailyTotalWidgetBuilder: _buildDailyTotalBuilder()),
      ),
      floatingActionButton: AddTransactionButton(initialDate: widget.args.selectedDate),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        spacing: AppUIConstants.defaultSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt_long, size: AppUIConstants.largeIconSize, color: AppColorConstants.grey),
          Text('Chưa có giao dịch trong ngày này', style: AppTextStyle.greyS12),
        ],
      ),
    );
  }
}
