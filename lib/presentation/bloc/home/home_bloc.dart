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
  StreamSubscription<AppStreamData>? _refreshSubscription;

  HomeBloc(this.transactionService, this.categoryService) : super(const HomeState()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<RefreshTransactions>(_onRefreshTransactions);
    on<ChangeDate>(_onChangeDate);
    on<LoadMore>(_onLoadMore);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);

    _refreshSubscription = AppStreamEvent.eventStreamStatic.listen((data) {
      if (data.event == AppEvent.loadItemLatestTransaction) {
        add(const RefreshTransactions());
      }
      if (data.event == AppEvent.updateExistItemTransaction) {
        final int transactionId = data.payload as int;
        add(UpdateTransaction(transactionId));

      }
    });
    add(const LoadTransactions());
  }
  Future<void> _onUpdateTransaction(UpdateTransaction event, Emitter<HomeState> emit) async {
    try {
      final updatedTx = await transactionService.getTransactionById(event.transactionId);
      if (updatedTx == null) return;

      // ✅ Tìm và thay thế transaction cũ trong danh sách
      final updatedTransactions = state.transactions.map((tx) {
        return tx.id == updatedTx.id ? updatedTx : tx;
      }).toList();

      // ✅ Group lại và tính lại daily totals
      final updatedGrouped = transactionService.groupByDate(updatedTransactions);
      final updatedDailyTotals = _calculateDailyTotals(updatedGrouped, state.categoriesMap);

      emit(state.copyWith(
        transactions: updatedTransactions,
        groupedTransactions: updatedGrouped,
        dailyTotals: updatedDailyTotals,
      ));
    } catch (e) {
      logger.e('HomeBloc: Error in update transaction: $e');
    }
  }
  Map<String, DailyTransactionTotal> _calculateDailyTotals(
      Map<String, List<Transaction>> grouped,
      Map<int, TransactionCategory> categoriesMap,
      ) {
    final Map<String, DailyTransactionTotal> dailyTotals = {};

    grouped.forEach((dateKey, txList) {
      double income = 0;
      double expense = 0;
      double transfer = 0;

      for (final tx in txList) {
        final cat = categoriesMap[tx.transactionCategoryId];
        switch (cat?.transactionType) {
          case TransactionType.income:
            income += tx.amount;
            break;
          case TransactionType.expense:
            expense += tx.amount;
            break;
          case TransactionType.transfer:
            transfer += tx.amount;
            break;
          default:
            break;
        }
      }

      dailyTotals[dateKey] = DailyTransactionTotal(
        income: income,
        expense: expense,
        transfer: transfer,
      );
    });

    return dailyTotals;
  }


  Future<void> _onDeleteTransaction(DeleteTransaction event, Emitter<HomeState> emit) async {
    try {
      // Gọi service xóa trên DB (hoặc API)
      final success = await transactionService.deleteTransaction(event.transactionId);
      if (!success) return;

      // ✅ Cập nhật state dựa trên state hiện tại, không cần gọi lại service
      final updatedTransactions = state.transactions
          .where((t) => t.id != event.transactionId)
          .toList();

      final updatedGrouped = transactionService.groupByDate(updatedTransactions);
      final updatedDailyTotals = _calculateDailyTotals(updatedGrouped, state.categoriesMap);

      emit(state.copyWith(
        transactions: updatedTransactions,
        groupedTransactions: updatedGrouped,
        dailyTotals: updatedDailyTotals,
        totalRecords: (state.totalRecords ?? 1) - 1,
      ));
    } catch (e) {
      logger.e('HomeBloc: Error deleting transaction: $e');
    }
  }

  Future<void> _onLoadMore(LoadMore event, Emitter<HomeState> emit) async {
    if (state.totalRecords == null || state.totalRecords == 0) return;
    if (state.transactions.length >= state.totalRecords!) return;
    if (state.isLoadingMore) return;

    final nextPage = state.pageIndex + 1;
    emit(state.copyWith(isLoadingMore: true, pageIndex: nextPage));

    try {
      final currentDate = state.selectedDate ?? DateTime.now();
      final data = await transactionService.getTransactionsInMonth(
        year: currentDate.year,
        month: currentDate.month,
        pageIndex: nextPage,
      );

      final newTransactions = [...state.transactions];
      for (final tx in data.transactions) {
        if (!newTransactions.any((old) => old.id == tx.id)) {
          newTransactions.add(tx);
        }
      }

      final updatedGrouped = Map<String, List<Transaction>>.from(state.groupedTransactions);
      final newGrouped = transactionService.groupByDate(data.transactions);

      for (final entry in newGrouped.entries) {
        updatedGrouped.putIfAbsent(entry.key, () => []).addAll(entry.value);
        updatedGrouped[entry.key]!.sort((a, b) => b.date.compareTo(a.date));
      }

      final dailyTotals = _calculateDailyTotals(updatedGrouped, state.categoriesMap);

      emit(state.copyWith(
        transactions: newTransactions,
        groupedTransactions: updatedGrouped,
        dailyTotals: dailyTotals,
        isLoadingMore: false,
      ));
    } catch (e) {
      logger.e('HomeBloc: Error in load more: $e');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<MonthTransactionData> getTransactionInMonth({required int year, required int month, int? pageIndex}) async {
    try {
      final currentDate = state.selectedDate ?? DateTime.now();
      final result = await transactionService.getTransactionsInMonth(year: currentDate.year, month: currentDate.month);
      final groupedTransactions = transactionService.groupByDate(result.transactions);
      final allCategories = await categoryService.getAll();
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
      final dailyTotals = _calculateDailyTotals(data.groupedTransactions, data.categoriesMap);
      emit(state.copyWith(
        totalRecords: data.totalRecords,
        transactions: data.transactions,
        groupedTransactions: data.groupedTransactions,
        categoriesMap: data.categoriesMap,
        dailyTotals: dailyTotals,
      ));
    } catch (error) {
      logger.e('HomeBloc: Error in load transactions: $error');
      emit(state.copyWith(groupedTransactions: {}, transactions: []));
    }
  }

  Future<void> _onRefreshTransactions(RefreshTransactions event, Emitter<HomeState> emit) async {
    try {
      final selectedDate = state.selectedDate ?? DateTime.now();
      final lastTransaction = await transactionService.getLastTransactionInMonth(
        selectedDate.year,
        selectedDate.month,
      );

      if (lastTransaction != null &&
          !state.transactions.any((t) => t.id == lastTransaction.id)) {
        final updatedTransactions = [lastTransaction, ...state.transactions];
        final updatedGrouped = transactionService.groupByDate(updatedTransactions);
        final dailyTotals = _calculateDailyTotals(updatedGrouped, state.categoriesMap);

        emit(state.copyWith(
          transactions: updatedTransactions,
          groupedTransactions: updatedGrouped,
          dailyTotals: dailyTotals,
          totalRecords: (state.totalRecords ?? 0) + 1,
        ));
      }
    } catch (error) {
      logger.e('HomeBloc: Error in refresh: $error');
      add(const LoadTransactions());
    }
  }


  Future<void> _onChangeDate(ChangeDate event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      selectedDate: event.date,
      transactions: [],
      groupedTransactions: {},
      dailyTotals: {},
      totalRecords: 0,
      pageIndex: 0,
      isLoadingMore: false,
    ));

    try {
      final data = await getTransactionInMonth(
        year: event.date.year,
        month: event.date.month,
      );

      final dailyTotals = _calculateDailyTotals(data.groupedTransactions, data.categoriesMap);

      emit(state.copyWith(
        selectedDate: event.date,
        transactions: data.transactions,
        groupedTransactions: data.groupedTransactions,
        categoriesMap: data.categoriesMap,
        dailyTotals: dailyTotals,
        totalRecords: data.totalRecords,
        pageIndex: 0,
        isLoadingMore: false,
      ));
    } catch (error) {
      logger.e('HomeBloc: Error in change date: $error');
    }
  }
  @override
  Future<void> close() {
    _refreshSubscription?.cancel();
    return super.close();
  }
}
