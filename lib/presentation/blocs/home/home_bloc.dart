import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/repositories/repositories.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TransactionRepository transactionRepository;
  final TransactionCategoryRepository categoryRepository;
  StreamSubscription<AppStreamData>? _refreshSubscription;

  HomeBloc(this.transactionRepository, this.categoryRepository)
    : super(const HomeState()) {
    on<HomeLoadTransactions>(_onLoadTransactions);
    on<HomeChangeDate>(_onChangeDate);
    on<HomeLoadMore>(
      _onLoadMore,
      transformer: DebounceUtils.restartableDebounce<HomeLoadMore>(
        AppUIConstants.loadMoreDebounceDuration,
      ),
    );
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
          final bool isInCurrentMonth = _isTransactionInCurrentMonth(tx);
          if (!isInCurrentMonth) return;
          add(HomeInsertTransaction(tx));
          break;
        case AppEvent.deleteTransaction:
          final id = data.payload as int;
          add(HomeDeleteTransaction(id));
          break;
        default:
          break;
      }
    });
    add(const HomeLoadTransactions());
  }

  bool _isTransactionInCurrentMonth(Transaction transaction) {
    final currentDate = state.selectedDate ?? DateTime.now();
    return AppDateUtils.isDateInCurrentMonth(transaction.date, currentDate);
  }

  Future<void> _onInsertTransaction(
    HomeInsertTransaction event,
    Emitter<HomeState> emit,
  ) async {
    final updated = [event.transaction, ...state.transactions];
    final grouped = transactionRepository.groupByDate(updated);

    emit(
      state.copyWith(
        transactions: updated,
        groupedTransactions: grouped,
        totalRecords: (state.totalRecords ?? 0) + 1,
      ),
    );
  }

  Future<void> _onUpdateTransaction(
    HomeUpdateTransaction event,
    Emitter<HomeState> emit,
  ) async {
    final updatedTransaction = event.transaction;

    final oldTransaction = state.transactions
        .where((t) => t.id == updatedTransaction.id)
        .firstOrNull;

    final wasOldInCurrentMonth = oldTransaction != null;
    final isNewInCurrentMonth = _isTransactionInCurrentMonth(
      updatedTransaction,
    );

    Future<void> emitUpdated(List<Transaction> updatedTransactions) async {
      final grouped = transactionRepository.groupByDate(updatedTransactions);

      emit(
        state.copyWith(
          transactions: updatedTransactions,
          groupedTransactions: grouped,
        ),
      );
    }

    if (wasOldInCurrentMonth && isNewInCurrentMonth) {
      final updatedTransactions = state.transactions
          .map((t) => t.id == updatedTransaction.id ? updatedTransaction : t)
          .toList();

      await emitUpdated(updatedTransactions);
      return;
    }

    if (wasOldInCurrentMonth && !isNewInCurrentMonth) {
      final updatedTransactions = state.transactions
          .where((t) => t.id != updatedTransaction.id)
          .toList();

      await emitUpdated(updatedTransactions);
      return;
    }

    if (!wasOldInCurrentMonth && isNewInCurrentMonth) {
      final updatedTransactions = [updatedTransaction, ...state.transactions];
      await emitUpdated(updatedTransactions);
      return;
    }

    await emitUpdated(<Transaction>[]);
  }

  Future<void> _onLoadTransactions(
    HomeLoadTransactions event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final date = state.selectedDate ?? DateTime.now();

      final pageEither = await transactionRepository.getTransactionsInMonth(
        year: date.year,
        month: date.month,
      );
      final catsEither = await categoryRepository.getAll();

      final PagedTransactionResult page = pageEither.getOrElse(
        () => PagedTransactionResult(
          transactions: const <Transaction>[],
          totalRecords: 0,
        ),
      );
      final List<TransactionCategory> categories = catsEither.getOrElse(
        () => <TransactionCategory>[],
      );

      final grouped = transactionRepository.groupByDate(page.transactions);
      final categoriesMap = {for (final c in categories) c.id!: c};
      emit(
        state.copyWith(
          transactions: page.transactions,
          groupedTransactions: grouped,
          categoriesMap: categoriesMap,
          totalRecords: page.totalRecords,
        ),
      );
    } catch (e) {
      emit(state.copyWith(transactions: [], groupedTransactions: {}));
    }
  }

  Future<void> _onChangeDate(
    HomeChangeDate event,
    Emitter<HomeState> emit,
  ) async {
    final selectedDate = state.selectedDate ?? DateTime.now();
    if (selectedDate.year == event.date.year &&
        selectedDate.month == event.date.month) {
      return;
    }
    emit(
      state.copyWith(
        selectedDate: event.date,
        transactions: [],
        groupedTransactions: {},
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
      final resultEither = await transactionRepository.getTransactionsInMonth(
        year: date.year,
        month: date.month,
        pageIndex: nextPage,
      );
      if (resultEither.isLeft()) {
        emit(state.copyWith(isLoadingMore: false));
        return;
      }
      final page = resultEither.getOrElse(
        () => PagedTransactionResult(
          transactions: const <Transaction>[],
          totalRecords: 0,
        ),
      );

      final updatedTransactions = [...state.transactions];
      final existingIds = updatedTransactions.map((t) => t.id).toSet();
      for (final tx in page.transactions) {
        if (!existingIds.contains(tx.id)) {
          updatedTransactions.add(tx);
        }
      }

      final grouped = transactionRepository.groupByDate(updatedTransactions);

      emit(
        state.copyWith(
          transactions: updatedTransactions,
          groupedTransactions: grouped,
          pageIndex: nextPage,
          isLoadingMore: false,
          totalRecords: page.totalRecords,
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
      final transactionToDelete = state.transactions
          .where((t) => t.id == event.transactionId)
          .firstOrNull;
      if (transactionToDelete == null) return;
      final updated = state.transactions
          .where((t) => t.id != event.transactionId)
          .toList();
      final grouped = transactionRepository.groupByDate(updated);

      emit(
        state.copyWith(
          transactions: updated,
          groupedTransactions: grouped,
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
