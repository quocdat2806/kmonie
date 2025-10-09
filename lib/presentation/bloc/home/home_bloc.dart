import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/export.dart';
import '../../../core/service/export.dart';
import '../../../core/stream/export.dart';
import '../../../core/util/export.dart';
import '../../../entity/export.dart';
import 'home_event.dart';
import 'home_state.dart';



class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TransactionService transactionService;
  final TransactionCategoryService categoryService;
  StreamSubscription<AppStreamData>? _refreshSubscription;

  HomeBloc(this.transactionService, this.categoryService)
    : super(const HomeState()) {
    on<HomeLoadTransactions>(_onLoadTransactions);
    on<HomeChangeDate>(_onChangeDate);
    on<HomeLoadMore>(_onLoadMore);
    on<HomeDeleteTransaction>(_onDeleteTransaction);
    on<HomeInsertTransaction>(_onInsertTransaction);
    on<HomeUpdateTransaction>(_onUpdateTransaction);

    _refreshSubscription = AppStreamEvent.eventStreamStatic.listen((data) {
      switch (data.event) {
        case AppEvent.updateTransaction:
          final tx = data.payload as Transaction;
          add(HomeUpdateTransaction(tx));
          break;
        case AppEvent.insertTransaction:
          final tx = data.payload as Transaction;
          add(HomeInsertTransaction(tx));
          break;
        case AppEvent.deleteTransaction:
          final id = data.payload as int;
          add(HomeDeleteTransaction(id));
          break;
      }
    });
    add(const HomeLoadTransactions());
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

  Future<void> _onInsertTransaction(
    HomeInsertTransaction event,
    Emitter<HomeState> emit,
  ) async {
    final updated = [event.transaction, ...state.transactions];
    final grouped = transactionService.groupByDate(updated);
    final dailyTotals = _calculateDailyTotals(grouped, state.categoriesMap);

    emit(
      state.copyWith(
        transactions: updated,
        groupedTransactions: grouped,
        dailyTotals: dailyTotals,
        totalRecords: (state.totalRecords ?? 0) + 1,
      ),
    );
  }

  Future<void> _onUpdateTransaction(
    HomeUpdateTransaction event,
    Emitter<HomeState> emit,
  ) async {
    final updated = state.transactions
        .map((t) => t.id == event.transaction.id ? event.transaction : t)
        .toList();
    final grouped = transactionService.groupByDate(updated);
    final dailyTotals = _calculateDailyTotals(grouped, state.categoriesMap);
    emit(
      state.copyWith(
        transactions: updated,
        groupedTransactions: grouped,
        dailyTotals: dailyTotals,
      ),
    );
  }

  Future<void> _onLoadTransactions(
    HomeLoadTransactions event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final date = state.selectedDate ?? DateTime.now();
      final result = await transactionService.getTransactionsInMonth(
        year: date.year,
        month: date.month,
      );

      final grouped = transactionService.groupByDate(result.transactions);
      final categories = await categoryService.getAll();
      final categoriesMap = {for (final c in categories) c.id!: c};
      final dailyTotals = _calculateDailyTotals(grouped, categoriesMap);

      emit(
        state.copyWith(
          transactions: result.transactions,
          groupedTransactions: grouped,
          categoriesMap: categoriesMap,
          totalRecords: result.totalRecords,
          dailyTotals: dailyTotals,
        ),
      );
    } catch (e) {
      logger.e('HomeBloc: Error in load transactions: $e');
      emit(state.copyWith(transactions: [], groupedTransactions: {}));
    }
  }

  Future<void> _onChangeDate(HomeChangeDate event, Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
        selectedDate: event.date,
        transactions: [],
        groupedTransactions: {},
        dailyTotals: {},
        totalRecords: 0,
        pageIndex: 0,
        isLoadingMore: false,
      ),
    );
    add(const HomeLoadTransactions());
  }

  Future<void> _onLoadMore(HomeLoadMore event, Emitter<HomeState> emit) async {
    if (state.isLoadingMore) return;
    if (state.totalRecords == null ||
        state.transactions.length >= state.totalRecords!) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.pageIndex + 1;
    final date = state.selectedDate ?? DateTime.now();

    try {
      final result = await transactionService.getTransactionsInMonth(
        year: date.year,
        month: date.month,
        pageIndex: nextPage,
      );

      final updatedTransactions = [...state.transactions];
      for (final tx in result.transactions) {
        if (!updatedTransactions.any((old) => old.id == tx.id)) {
          updatedTransactions.add(tx);
        }
      }

      final grouped = transactionService.groupByDate(updatedTransactions);
      final dailyTotals = _calculateDailyTotals(grouped, state.categoriesMap);

      emit(
        state.copyWith(
          transactions: updatedTransactions,
          groupedTransactions: grouped,
          dailyTotals: dailyTotals,
          pageIndex: nextPage,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      logger.e('HomeBloc: Error in load more: $e');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onDeleteTransaction(
    HomeDeleteTransaction event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final success = await transactionService.deleteTransaction(
        event.transactionId,
      );
      if (!success) return;

      final updated = state.transactions
          .where((t) => t.id != event.transactionId)
          .toList();
      final grouped = transactionService.groupByDate(updated);
      final dailyTotals = _calculateDailyTotals(grouped, state.categoriesMap);

      emit(
        state.copyWith(
          transactions: updated,
          groupedTransactions: grouped,
          dailyTotals: dailyTotals,
          totalRecords: (state.totalRecords ?? 1) - 1,
        ),
      );
    } catch (e) {
      logger.e('HomeBloc: Error deleting transaction: $e');
    }
  }

  @override
  Future<void> close() {
    _refreshSubscription?.cancel();
    return super.close();
  }
}
