import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/enum/export.dart';
import '../../../core/stream/export.dart';
import '../../../core/util/date.dart';
import '../../../core/constant/export.dart';
import '../../../core/text_style/export.dart';
import '../../../entity/export.dart';
import '../../widgets/export.dart';

class DailyTransactionPageArgs {
  final DateTime selectedDate;
  final Map<String, List<Transaction>> groupedTransactions;
  final Map<int, TransactionCategory> categoriesMap;
  final Widget Function(String dateKey)? dailyTotalBuilder;

  const DailyTransactionPageArgs({required this.selectedDate, required this.groupedTransactions, required this.categoriesMap, this.dailyTotalBuilder});
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

  @override
  Widget build(BuildContext context) {
    final dateStr = AppDateUtils.formatDate(widget.args.selectedDate);

    final bool isEmpty = _groupedTransactions.isEmpty || _groupedTransactions.values.every((list) => list.isEmpty);

    return Scaffold(
      appBar: CustomAppBar(title: 'Giao dịch $dateStr'),
      body: SafeArea(
        child: isEmpty ? _buildEmptyState(context) : TransactionList(groupedTransactions: _groupedTransactions, categoriesMap: _categoriesMap, dailyTotalWidgetBuilder: widget.args.dailyTotalBuilder),
      ),
      floatingActionButton:  AddTransactionButton(
        initialDate: widget.args.selectedDate,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return  Center(
      child: Column(
        spacing: UIConstants.defaultSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt_long, size: UIConstants.largeIconSize, color: ColorConstants.grey),
          Text('Chưa có giao dịch trong ngày này', style: AppTextStyle.greyS12),
        ],
      ),
    );
  }
}
