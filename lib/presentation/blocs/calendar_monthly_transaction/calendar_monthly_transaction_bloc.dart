import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/repositories/repositories.dart';

import 'calendar_monthly_transaction_event.dart';
import 'calendar_monthly_transaction_state.dart';

class CalendarMonthlyTransactionBloc
    extends
        Bloc<CalendarMonthlyTransactionEvent, CalendarMonthTransactionState> {
  final TransactionRepository transactionRepository;
  final TransactionCategoryRepository categoryRepository;

  StreamSubscription<AppStreamData>? _sub;

  CalendarMonthlyTransactionBloc(
    this.transactionRepository,
    this.categoryRepository,
  ) : super(CalendarMonthTransactionState(selectedDate: DateTime.now())) {
    on<LoadMonthData>(_onLoadMonthData);
    on<ChangeSelectedDate>(_onChangeSelectedDate);
    on<CalendarMonthlyTransactionInsertTransaction>(_onInsertTransaction);
    on<CalendarMonthlyTransactionUpdateTransaction>(_onUpdateTransaction);
    on<CalendarMonthlyTransactionDeleteTransaction>(_onDeleteTransaction);
    on<ChangeMonthYear>(_onChangeMonthYear);

    _sub = AppStreamEvent.eventStreamStatic.listen((data) {
      switch (data.event) {
        case AppEvent.insertTransaction:
          final transaction = data.payload as Transaction;
          add(CalendarMonthlyTransactionEvent.insertTransaction(transaction));
          break;
        case AppEvent.updateTransaction:
          final transaction = data.payload as Transaction;
          add(CalendarMonthlyTransactionEvent.updateTransaction(transaction));
          break;
        case AppEvent.deleteTransaction:
          add(
            CalendarMonthlyTransactionEvent.deleteTransaction(
              data.payload as int,
            ),
          );
          break;
        default:
          break;
      }
    });

    add(const CalendarMonthlyTransactionEvent.loadMonthData());
  }

  Future<void> _onLoadMonthData(
    LoadMonthData event,
    Emitter<CalendarMonthTransactionState> emit,
  ) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));

    final now = DateTime.now();
    final year = event.year ?? now.year;
    final month = event.month ?? now.month;

    final transactionsResult = await transactionRepository
        .getTransactionsInMonth(year: year, month: month, pageSize: 100);

    await transactionsResult.fold(
      (failure) async {
        logger.e(
          'CalendarMonthlyTransactionBloc: error loading transactions: ${failure.message}',
        );
        emit(state.copyWith(loadStatus: LoadStatus.error));
      },
      (pagedResult) async {
        final grouped = transactionRepository.groupByDate(
          pagedResult.transactions,
        );
        final categoriesResult = await categoryRepository.getAll();

        await categoriesResult.fold(
          (failure) async {
            logger.e(
              'CalendarMonthlyTransactionBloc: error loading categories: ${failure.message}',
            );
            emit(state.copyWith(loadStatus: LoadStatus.error));
          },
          (categories) async {
            final categoriesMap = {for (final c in categories) c.id!: c};
            final currentSelectedDate = state.selectedDate ?? DateTime.now();

            emit(
              state.copyWith(
                loadStatus: LoadStatus.success,
                groupedTransactions: Map.from(grouped),
                categoriesMap: Map.from(categoriesMap),
                selectedDate: DateTime(year, month, currentSelectedDate.day),
                currentYear: year,
                currentMonth: month,
              ),
            );
          },
        );
      },
    );
  }

  void _onChangeSelectedDate(
    ChangeSelectedDate event,
    Emitter<CalendarMonthTransactionState> emit,
  ) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onInsertTransaction(
    CalendarMonthlyTransactionInsertTransaction event,
    Emitter<CalendarMonthTransactionState> emit,
  ) async {
    final tx = event.transaction;

    if (state.currentYear == null || state.currentMonth == null) return;
    final bool isInCurrentMonth = AppDateUtils.isDateInCurrentMonth(
      tx.date,
      DateTime(state.currentYear!, state.currentMonth!),
    );
    if (!isInCurrentMonth) return;
    await _updateTransactionInState(tx, emit);
  }

  void _onUpdateTransaction(
    CalendarMonthlyTransactionUpdateTransaction event,
    Emitter<CalendarMonthTransactionState> emit,
  ) async {
    final tx = event.transaction;

    if (state.currentYear == null || state.currentMonth == null) return;

    Transaction? oldTransaction;
    for (final entry in state.groupedTransactions.entries) {
      try {
        final found = entry.value.firstWhere((t) => t.id == tx.id);
        if (found != tx) {
          oldTransaction = found;
          break;
        }
      } catch (e) {
        continue;
      }
    }

    if (oldTransaction != null &&
        !AppDateUtils.isSameDate(oldTransaction.date, tx.date)) {
      await _removeTransactionFromState(oldTransaction, emit);
    }

    await _updateTransactionInState(tx, emit);
  }

  void _onDeleteTransaction(
    CalendarMonthlyTransactionDeleteTransaction event,
    Emitter<CalendarMonthTransactionState> emit,
  ) async {
    if (state.currentYear == null || state.currentMonth == null) return;

    Transaction? transactionToDelete;
    for (final entry in state.groupedTransactions.entries) {
      try {
        final found = entry.value.firstWhere((t) => t.id == event.id);
        transactionToDelete = found;
        break;
      } catch (e) {
        continue;
      }
    }

    if (transactionToDelete != null) {
      await _removeTransactionFromState(transactionToDelete, emit);
    }
  }

  Future<void> _updateTransactionInState(
    Transaction tx,
    Emitter<CalendarMonthTransactionState> emit,
  ) async {
    final dateKey = AppDateUtils.formatDateKey(tx.date);

    final newGrouped = Map<String, List<Transaction>>.from(
      state.groupedTransactions,
    );

    final existingDayTransactions = newGrouped[dateKey];

    if (existingDayTransactions == null) {
      newGrouped[dateKey] = [tx];
      emit(
        state.copyWith(
          groupedTransactions: newGrouped,
          loadStatus: LoadStatus.success,
        ),
      );
      return;
    }

    final dayTransactions = List<Transaction>.from(existingDayTransactions);
    final existingIndex = dayTransactions.indexWhere((t) => t.id == tx.id);

    if (existingIndex >= 0) {
      dayTransactions[existingIndex] = tx;
    } else {
      dayTransactions.add(tx);
    }

    newGrouped[dateKey] = dayTransactions;

    emit(
      state.copyWith(
        groupedTransactions: newGrouped,
        loadStatus: LoadStatus.success,
      ),
    );
  }

  Future<void> _removeTransactionFromState(
    Transaction tx,
    Emitter<CalendarMonthTransactionState> emit,
  ) async {
    final dateKey = AppDateUtils.formatDateKey(tx.date);

    final newGrouped = Map<String, List<Transaction>>.from(
      state.groupedTransactions,
    );

    final existingDayTransactions = newGrouped[dateKey];
    if (existingDayTransactions == null) {
      return;
    }

    final dayTransactions = List<Transaction>.from(existingDayTransactions)
      ..removeWhere((t) => t.id == tx.id);

    if (dayTransactions.isEmpty) {
      newGrouped.remove(dateKey);
    } else {
      newGrouped[dateKey] = dayTransactions;
    }

    emit(
      state.copyWith(
        groupedTransactions: newGrouped,
        loadStatus: LoadStatus.success,
      ),
    );
  }

  void _onChangeMonthYear(
    ChangeMonthYear event,
    Emitter<CalendarMonthTransactionState> emit,
  ) {
    final now = DateTime.now();
    final year = event.year ?? now.year;
    final month = event.month ?? now.month;

    add(
      CalendarMonthlyTransactionEvent.loadMonthData(year: year, month: month),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
