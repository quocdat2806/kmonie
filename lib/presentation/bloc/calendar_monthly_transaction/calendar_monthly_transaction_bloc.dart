import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'calendar_monthly_transaction_event.dart';
import 'calendar_monthly_transaction_state.dart';

class CalendarMonthlyTransactionBloc extends Bloc<CalendarMonthlyTransactionEvent, CalendarMonthTransactionState> {
  final TransactionRepository transactionRepository;
  final TransactionCategoryRepository categoryRepository;

  StreamSubscription<AppStreamData>? _sub;

  CalendarMonthlyTransactionBloc(this.transactionRepository, this.categoryRepository) : super(CalendarMonthTransactionState(selectedDate: DateTime.now())) {
    on<LoadMonthData>(_onLoadMonthData);
    on<ChangeSelectedDate>(_onChangeSelectedDate);
    on<CalendarMonthlyTransactionInsertTransaction>(_onInsertTransaction);
    on<CalendarMonthlyTransactionUpdateTransaction>(_onUpdateTransaction);
    on<CalendarMonthlyTransactionDeleteTransaction>(_onDeleteTransaction);
    on<ChangeMonthYear>(_onChangeMonthYear);

    _sub = AppStreamEvent.eventStreamStatic.listen((data) {
      switch (data.event) {
        case AppEvent.insertTransaction:
          if (data.payload is Transaction) {
            final transaction = data.payload as Transaction;
            final bool isInCurrentMonth = _isDateInCurrentMonthRange(transaction.date);
            if (isInCurrentMonth) {
              add(CalendarMonthlyTransactionInsertTransaction(transaction));
            }
          }
          break;
        case AppEvent.updateTransaction:
          if (data.payload is Transaction) {
            final transaction = data.payload as Transaction;
            add(CalendarMonthlyTransactionUpdateTransaction(transaction));
          }
          break;
        case AppEvent.deleteTransaction:
          if (data.payload is int) {
            add(CalendarMonthlyTransactionDeleteTransaction(data.payload as int));
          }
          break;
        default:
          break;
      }
    });

    add(const LoadMonthData());
  }

  bool _isDateInCurrentMonthRange(DateTime date) {
    final currentSelectedDate = state.selectedDate ?? DateTime.now();
    return date.year == currentSelectedDate.year && date.month == currentSelectedDate.month;
  }

  Future<void> _onLoadMonthData(LoadMonthData event, Emitter<CalendarMonthTransactionState> emit) async {
    emit(state.copyWith(isLoading: true));

    final now = DateTime.now();
    final year = event.year ?? now.year;
    final month = event.month ?? now.month;

    final transactionsResult = await transactionRepository.getTransactionsInMonth(year: year, month: month, pageSize: 9999);

    await transactionsResult.fold(
      (failure) async {
        logger.e('CalendarMonthlyTransactionBloc: error loading transactions: ${failure.message}');
        emit(state.copyWith(isLoading: false));
      },
      (pagedResult) async {
        final grouped = transactionRepository.groupByDate(pagedResult.transactions);
        final categoriesResult = await categoryRepository.getAll();

        await categoriesResult.fold(
          (failure) async {
            logger.e('CalendarMonthlyTransactionBloc: error loading categories: ${failure.message}');
            emit(state.copyWith(isLoading: false));
          },
          (categories) async {
            final categoriesMap = {for (final c in categories) c.id!: c};

            final currentSelectedDate = state.selectedDate ?? DateTime.now();
            emit(state.copyWith(isLoading: false, groupedTransactions: grouped, categoriesMap: categoriesMap, selectedDate: DateTime(year, month, currentSelectedDate.day)));
          },
        );
      },
    );
  }

  void _onChangeSelectedDate(ChangeSelectedDate event, Emitter<CalendarMonthTransactionState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onInsertTransaction(CalendarMonthlyTransactionInsertTransaction event, Emitter<CalendarMonthTransactionState> emit) {
    final tx = event.transaction;
    final updatedGroupedTransactions = Map<String, List<Transaction>>.from(state.groupedTransactions);

    final dateKey = AppDateUtils.formatDateKey(tx.date);
    final existingTransactions = updatedGroupedTransactions[dateKey] ?? [];
    if (!existingTransactions.any((e) => e.id == tx.id)) {
      existingTransactions.insert(0, tx);
      updatedGroupedTransactions[dateKey] = existingTransactions;
    }

    emit(state.copyWith(groupedTransactions: updatedGroupedTransactions));
  }

  void _onUpdateTransaction(CalendarMonthlyTransactionUpdateTransaction event, Emitter<CalendarMonthTransactionState> emit) {
    final tx = event.transaction;

    // Check if the updated transaction is still in current month
    final isInCurrentMonth = _isDateInCurrentMonthRange(tx.date);

    final updatedGroupedTransactions = Map<String, List<Transaction>>.from(state.groupedTransactions);

    if (isInCurrentMonth) {
      // Transaction is still in current month → update it
      final dateKey = AppDateUtils.formatDateKey(tx.date);
      final dayTransactions = List<Transaction>.from(updatedGroupedTransactions[dateKey] ?? [])
        ..removeWhere((t) => t.id == tx.id)
        ..add(tx);
      updatedGroupedTransactions[dateKey] = dayTransactions;
    } else {
      // Transaction moved to different month → remove it from current month
      for (final entry in updatedGroupedTransactions.entries) {
        final transactions = entry.value;
        final updatedTransactions = transactions.where((t) => t.id != tx.id).toList();
        if (updatedTransactions.isEmpty) {
          updatedGroupedTransactions.remove(entry.key);
        } else {
          updatedGroupedTransactions[entry.key] = updatedTransactions;
        }
      }
    }

    emit(state.copyWith(groupedTransactions: updatedGroupedTransactions));
  }

  void _onDeleteTransaction(CalendarMonthlyTransactionDeleteTransaction event, Emitter<CalendarMonthTransactionState> emit) async {
    final transactionId = event.id;

    // Find the transaction to delete
    Transaction? transactionToDelete;
    String? dateKeyToUpdate;

    for (final entry in state.groupedTransactions.entries) {
      final transactions = entry.value;
      final found = transactions.where((t) => t.id == transactionId).firstOrNull;
      if (found != null) {
        transactionToDelete = found;
        dateKeyToUpdate = entry.key;
        break;
      }
    }

    if (transactionToDelete == null || dateKeyToUpdate == null) {
      return;
    }

    final updatedGroupedTransactions = Map<String, List<Transaction>>.from(state.groupedTransactions);
    final dayTransactions = List<Transaction>.from(updatedGroupedTransactions[dateKeyToUpdate] ?? [])..removeWhere((t) => t.id == transactionId);

    if (dayTransactions.isEmpty) {
      updatedGroupedTransactions.remove(dateKeyToUpdate);
    } else {
      updatedGroupedTransactions[dateKeyToUpdate] = dayTransactions;
    }

    emit(state.copyWith(groupedTransactions: updatedGroupedTransactions));
  }

  void _onChangeMonthYear(ChangeMonthYear event, Emitter<CalendarMonthTransactionState> emit) {
    final now = DateTime.now();
    final year = event.year ?? now.year;
    final month = event.month ?? now.month;
    add(LoadMonthData(year: year, month: month));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
