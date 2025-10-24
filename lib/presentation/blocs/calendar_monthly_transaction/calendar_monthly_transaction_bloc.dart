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
            final bool isInCurrentMonth = state.currentYear != null && state.currentMonth != null ? AppDateUtils.isDateInCurrentMonth(transaction.date, DateTime(state.currentYear!, state.currentMonth!)) : false;
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
            emit(state.copyWith(isLoading: false, groupedTransactions: grouped, categoriesMap: categoriesMap, selectedDate: DateTime(year, month, currentSelectedDate.day), currentYear: year, currentMonth: month));
          },
        );
      },
    );
  }

  void _onChangeSelectedDate(ChangeSelectedDate event, Emitter<CalendarMonthTransactionState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onInsertTransaction(CalendarMonthlyTransactionInsertTransaction event, Emitter<CalendarMonthTransactionState> emit) async {
    final tx = event.transaction;

    // Check if transaction is in current month range
    if (state.currentYear == null || state.currentMonth == null) return;
    if (!AppDateUtils.isDateInCurrentMonth(tx.date, DateTime(state.currentYear!, state.currentMonth!))) return;

    // Reload data from database to ensure consistency
    if (state.currentYear != null && state.currentMonth != null) {
      add(LoadMonthData(year: state.currentYear, month: state.currentMonth));
    }
  }

  void _onUpdateTransaction(CalendarMonthlyTransactionUpdateTransaction event, Emitter<CalendarMonthTransactionState> emit) async {
    final tx = event.transaction;

    // Check if transaction affects current month (either old or new date)
    final affectsCurrentMonth = state.currentYear != null && state.currentMonth != null ? AppDateUtils.isDateInCurrentMonth(tx.date, DateTime(state.currentYear!, state.currentMonth!)) : false;

    // If transaction affects current month, reload data
    if (affectsCurrentMonth && state.currentYear != null && state.currentMonth != null) {
      add(LoadMonthData(year: state.currentYear, month: state.currentMonth));
    }
  }

  void _onDeleteTransaction(CalendarMonthlyTransactionDeleteTransaction event, Emitter<CalendarMonthTransactionState> emit) async {
    // Always reload data from database when deleting to ensure consistency
    if (state.currentYear != null && state.currentMonth != null) {
      add(LoadMonthData(year: state.currentYear, month: state.currentMonth));
    }
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
