import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/enum/app_event.dart';
import '../../../core/navigation/export.dart';
import '../../../core/stream/export.dart';
import '../../../core/util/date.dart';
import '../../../entity/export.dart';
import '../../widgets/transaction/transaction_list.dart';
import '../transaction_action/transaction_actions_page.dart';

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

    // 📝 Nếu ngày mới KHÔNG phải ngày hiện tại => xoá giao dịch cũ khỏi danh sách này
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

    // 📝 Nếu cùng ngày => update trong list hiện tại
    final key = _formatDateKey(tx.date);
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
      // Xóa key nào mà list rỗng để tránh map rỗng treo
      _groupedTransactions.removeWhere((_, list) => list.isEmpty);
    });
  }

  String _formatDateKey(DateTime date) => '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = '${widget.args.selectedDate.day.toString().padLeft(2, '0')}/${widget.args.selectedDate.month.toString().padLeft(2, '0')}/${widget.args.selectedDate.year}';

    final bool isEmpty = _groupedTransactions.isEmpty || _groupedTransactions.values.every((list) => list.isEmpty);

    return Scaffold(
      appBar: AppBar(title: Text('Giao dịch $dateStr'), centerTitle: true),
      body: SafeArea(
        child: isEmpty ? _buildEmptyState(context) : TransactionList(groupedTransactions: _groupedTransactions, categoriesMap: _categoriesMap, dailyTotalWidgetBuilder: widget.args.dailyTotalBuilder),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AppNavigator(context: context).push(RouterPath.transactionActions, extra: TransactionActionsPageArgs(selectedDate: widget.args.selectedDate));
        },
        icon: const Icon(Icons.add),
        label: const Text('Thêm giao dịch'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('Chưa có giao dịch trong ngày này', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}
