import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/export.dart';
import '../../../core/service/export.dart';
import '../../../core/stream/export.dart';
import '../../../core/util/export.dart';
import '../../../entity/export.dart';
import 'home_event.dart';
import 'home_state.dart';

class MonthTransactionData {
  final List<Transaction> transactions;
  final Map<String, List<Transaction>> groupedTransactions;
  final Map<int, TransactionCategory> categoriesMap;
  final int totalRecords;

  const MonthTransactionData({required this.transactions, required this.groupedTransactions, required this.categoriesMap, this.totalRecords = 0});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TransactionService transactionService;
  final TransactionCategoryService categoryService;
  StreamSubscription<AppEvent>? _refreshSubscription;

  HomeBloc(this.transactionService, this.categoryService) : super(const HomeState()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<RefreshTransactions>(_onRefreshTransactions);
    on<ChangeDate>(_onChangeDate);
    on<LoadMore>(_onLoadMore);
    _refreshSubscription = AppStreamEvent.eventStreamStatic.listen((event) {
      if (event == AppEvent.refreshHomeData) {
        add(const RefreshTransactions());
      }
    });
    add(const LoadTransactions());
  }
  Future<void> _onLoadMore(LoadMore event, Emitter<HomeState> emit) async {
    if (state.totalRecords == null || state.totalRecords == 0) return;

    if (state.transactions.length >= state.totalRecords!) return;
    if (state.isLoadingMore) return;
    final nextPage = state.pageIndex + 1;
    emit(state.copyWith(isLoadingMore: true, pageIndex: nextPage));

    try {
      final currentDate = state.selectedDate ?? DateTime.now();

      final data = await transactionService.getTransactionsInMonth(year: currentDate.year, month: currentDate.month, pageIndex: nextPage);

      final newTransactions = [...state.transactions];
      for (final tx in data.transactions) {
        if (!newTransactions.any((old) => old.id == tx.id)) {
          newTransactions.add(tx);
        }
      }

      final updatedGrouped = Map<String, List<Transaction>>.from(state.groupedTransactions);
      final newGrouped = _groupTransactionsByDate(data.transactions);

      for (final entry in newGrouped.entries) {
        if (updatedGrouped.containsKey(entry.key)) {
          final existing = updatedGrouped[entry.key]!;
          for (final tx in entry.value) {
            if (!existing.any((e) => e.id == tx.id)) {
              existing.add(tx);
            }
          }
          existing.sort((a, b) => b.date.compareTo(a.date));
        } else {
          updatedGrouped[entry.key] = entry.value;
        }
      }

      emit(state.copyWith(transactions: newTransactions, groupedTransactions: updatedGrouped, isLoadingMore: false));
    } catch (e) {
      logger.e('HomeBloc: Error in load more: $e');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<MonthTransactionData> getTransactionInMonth({required int year, required int month, int? pageIndex}) async {
    try {
      final currentDate = state.selectedDate ?? DateTime.now();
      final result = await transactionService.getTransactionsInMonth(year: currentDate.year, month: currentDate.month);
      final groupedTransactions = _groupTransactionsByDate(result.transactions);
      final allCategories = await categoryService.getAll();
      print("aaaa ${allCategories}");
      final categoriesMap = {for (final cat in allCategories) cat.id!: cat};
      return MonthTransactionData(totalRecords: result.totalRecords, transactions: result.transactions, groupedTransactions: groupedTransactions, categoriesMap: categoriesMap);
    } catch (error) {
      logger.e('HomeBloc: Error in load transactions: $error');
      rethrow;
    }
  }

  Future<void> _onLoadTransactions(LoadTransactions event, Emitter<HomeState> emit) async {
    try {
      final currentDate = state.selectedDate ?? DateTime.now();
      final data = await getTransactionInMonth(year: currentDate.year, month: currentDate.month);
      emit(state.copyWith(totalRecords: data.totalRecords, groupedTransactions: data.groupedTransactions, transactions: data.transactions, categoriesMap: data.categoriesMap));
    } catch (error) {
      logger.e('HomeBloc: Error in load transactions: $error');
      emit(state.copyWith(groupedTransactions: {}, transactions: []));
    }
  }

  Future<void> _onRefreshTransactions(RefreshTransactions event, Emitter<HomeState> emit) async {
    try {
      final selectedDate = state.selectedDate ?? DateTime.now();

      final lastTransaction = await transactionService.getLastTransactionInMonth(selectedDate.year, selectedDate.month);

      if (lastTransaction != null) {
        final existingTransaction = state.transactions.firstWhere((t) => t.id == lastTransaction.id, orElse: () => Transaction(id: -1, amount: 0, date: DateTime.now(), transactionCategoryId: 0));

        if (existingTransaction.id == -1) {
          logger.d('HomeBloc: Adding new transaction to list');
          final updatedTransactions = [lastTransaction, ...state.transactions];
          final groupedTransactions = _groupTransactionsByDate(updatedTransactions);

          emit(state.copyWith(transactions: updatedTransactions, groupedTransactions: groupedTransactions, totalRecords: (state.totalRecords ?? 0) + 1));
        } else {
          logger.d('HomeBloc: Transaction already exists, no update needed');
        }
      } else {
        logger.d('HomeBloc: No new transaction found in this month, skipping refresh');
      }
    } catch (error) {
      logger.e('HomeBloc: Error in refresh: $error');
      add(const LoadTransactions());
    }
  }

  Future<void> _onChangeDate(ChangeDate event, Emitter<HomeState> emit) async {
    final selectedDate = event.date;

    // 🧹 Reset state về mặc định trước khi load tháng mới
    emit(state.copyWith(selectedDate: selectedDate, transactions: [], groupedTransactions: {}, totalRecords: 0, pageIndex: 0, isLoadingMore: false));

    try {
      // 🔸 Load page đầu tiên của tháng mới
      final data = await getTransactionInMonth(year: selectedDate.year, month: selectedDate.month, pageIndex: 0);

      emit(state.copyWith(selectedDate: selectedDate, totalRecords: data.totalRecords, transactions: data.transactions, groupedTransactions: data.groupedTransactions, categoriesMap: data.categoriesMap, pageIndex: 0, isLoadingMore: false));
    } catch (error) {
      logger.e('HomeBloc: Error in change date: $error');
      emit(state.copyWith(groupedTransactions: {}, transactions: [], totalRecords: 0, isLoadingMore: false));
    }
  }

  Map<String, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final Map<String, List<Transaction>> grouped = {};

    for (final transaction in transactions) {
      final dateKey = _formatDateKey(transaction.date);
      grouped.putIfAbsent(dateKey, () => []).add(transaction);
    }
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final Map<String, List<Transaction>> sortedGrouped = {};
    for (final key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }

  String _formatDateKey(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Future<void> close() {
    _refreshSubscription?.cancel();
    return super.close();
  }
}
