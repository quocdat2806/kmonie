import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/entity/entity.dart';
import 'calendar_monthly_transaction_event.dart';
import 'calendar_monthly_transaction_state.dart';

class CalendarMonthlyTransactionBloc
    extends
        Bloc<CalendarMonthlyTransactionEvent, CalendarMonthTransactionState> {
  final TransactionService transactionService;
  final TransactionCategoryService categoryService;

  StreamSubscription<AppStreamData>? _sub;

  CalendarMonthlyTransactionBloc(this.transactionService, this.categoryService)
    : super(CalendarMonthTransactionState(selectedDate: DateTime.now())) {
    on<LoadMonthData>(_onLoadMonthData);
    on<ChangeSelectedDate>(_onChangeSelectedDate);
    on<CalendarMonthlyTransactionInsertTransaction>(_onInsertTransaction);
    on<CalendarMonthlyTransactionUpdateTransaction>(_onUpdateTransaction);
    on<CalendarMonthlyTransactionDeleteTransaction>(_onDeleteTransaction);
    on<ChangeMonthYear>(_onChangeMonthYear);

    _sub = AppStreamEvent.eventStreamStatic.listen((data) {
      switch (data.event) {
        case AppEvent.insertTransaction:
          add(
            CalendarMonthlyTransactionInsertTransaction(
              data.payload as Transaction,
            ),
          );
          break;
        case AppEvent.updateTransaction:
          add(
            CalendarMonthlyTransactionUpdateTransaction(
              data.payload as Transaction,
            ),
          );
          break;
        case AppEvent.deleteTransaction:
          add(CalendarMonthlyTransactionDeleteTransaction(data.payload as int));
          break;
      }
    });

    add(const LoadMonthData());
  }

  bool _isDateInCurrentMonthRange(DateTime date) {
    final currentSelectedDate = state.selectedDate ?? DateTime.now();
    return date.year == currentSelectedDate.year &&
        date.month == currentSelectedDate.month;
  }

  Future<void> _onLoadMonthData(
    LoadMonthData event,
    Emitter<CalendarMonthTransactionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final now = DateTime.now();
      final year = event.year ?? now.year;
      final month = event.month ?? now.month;

      final allTransactions = await transactionService.getTransactionsInMonth(
        year: year,
        month: month,
        pageSize: 9999,
      );

      final grouped = transactionService.groupByDate(
        allTransactions.transactions,
      );

      final categories = await categoryService.getAll();
      final categoriesMap = {for (final c in categories) c.id!: c};

      final dailyTotals = <int, DailyTransactionTotal>{};

      for (final entry in grouped.entries) {
        final date = AppDateUtils.parseDateKey(entry.key);

        double income = 0;
        double expense = 0;
        double transfer = 0;

        for (final tx in entry.value) {
          if (tx.transactionType == TransactionType.income.typeIndex) {
            income += tx.amount;
          } else if (tx.transactionType == TransactionType.expense.typeIndex) {
            expense += tx.amount;
          } else if (tx.transactionType == TransactionType.transfer.typeIndex) {
            transfer += tx.amount;
          }
        }

        dailyTotals[date.day] = DailyTransactionTotal(
          income: income,
          expense: expense,
          transfer: transfer,
        );
      }

      final currentSelectedDate = state.selectedDate ?? DateTime.now();
      emit(
        state.copyWith(
          isLoading: false,
          groupedTransactions: grouped,
          dailyTotals: dailyTotals,
          categoriesMap: categoriesMap,
          selectedDate: DateTime(year, month, currentSelectedDate.day),
        ),
      );
    } catch (e) {
      logger.e('❤️ ERROR: CalendarBloc error: $e');
      emit(state.copyWith(isLoading: false, dailyTotals: {}));
    }
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
  ) {
    final tx = event.transaction;
    final day = tx.date.day;
    final existing = state.dailyTotals[day] ?? const DailyTransactionTotal();
    final updatedDailyTotals = Map<int, DailyTransactionTotal>.from(
      state.dailyTotals,
    );
    final updatedGroupedTransactions = Map<String, List<Transaction>>.from(
      state.groupedTransactions,
    );

    if (tx.transactionType == TransactionType.income.typeIndex) {
      updatedDailyTotals[day] = existing.copyWith(
        income: existing.income + tx.amount,
      );
    } else if (tx.transactionType == TransactionType.expense.typeIndex) {
      updatedDailyTotals[day] = existing.copyWith(
        expense: existing.expense + tx.amount,
      );
    } else if (tx.transactionType == TransactionType.transfer.typeIndex) {
      updatedDailyTotals[day] = existing.copyWith(
        transfer: existing.transfer + tx.amount,
      );
    }

    final dateKey = AppDateUtils.formatDateKey(tx.date);
    final existingTransactions = updatedGroupedTransactions[dateKey] ?? [];
    if (!existingTransactions.any((e) => e.id == tx.id)) {
      existingTransactions.insert(0, tx);
      updatedGroupedTransactions[dateKey] = existingTransactions;
    }

    emit(
      state.copyWith(
        dailyTotals: updatedDailyTotals,
        groupedTransactions: updatedGroupedTransactions,
      ),
    );
  }

  void _onUpdateTransaction(
    CalendarMonthlyTransactionUpdateTransaction event,
    Emitter<CalendarMonthTransactionState> emit,
  ) {
    final tx = event.transaction;

    if (!_isDateInCurrentMonthRange(tx.date)) {
      return;
    }

    final day = tx.date.day;
    final updatedDailyTotals = Map<int, DailyTransactionTotal>.from(
      state.dailyTotals,
    );
    final updatedGroupedTransactions = Map<String, List<Transaction>>.from(
      state.groupedTransactions,
    );

    final dateKey = AppDateUtils.formatDateKey(tx.date);
    final dayTransactions = updatedGroupedTransactions[dateKey] ?? []
      ..removeWhere((t) => t.id == tx.id)
      ..add(tx);
    updatedGroupedTransactions[dateKey] = dayTransactions;

    double income = 0;
    double expense = 0;
    double transfer = 0;

    for (final t in dayTransactions) {
      if (t.transactionType == TransactionType.income.typeIndex) {
        income += t.amount;
      } else if (t.transactionType == TransactionType.expense.typeIndex) {
        expense += t.amount;
      } else if (t.transactionType == TransactionType.transfer.typeIndex) {
        transfer += t.amount;
      }
    }

    updatedDailyTotals[day] = DailyTransactionTotal(
      income: income,
      expense: expense,
      transfer: transfer,
    );

    emit(
      state.copyWith(
        dailyTotals: updatedDailyTotals,
        groupedTransactions: updatedGroupedTransactions,
      ),
    );
  }

  void _onDeleteTransaction(
    CalendarMonthlyTransactionDeleteTransaction event,
    Emitter<CalendarMonthTransactionState> emit,
  ) async {
    final transactionId = event.id;

    Transaction? transactionToDelete;
    for (final transactions in state.groupedTransactions.values) {
      final found = transactions.firstWhere(
        (t) => t.id == transactionId,
        orElse: () => Transaction(
          id: -1,
          amount: 0,
          date: DateTime.now(),
          transactionCategoryId: 0,
        ),
      );
      if (found.id == transactionId) {
        transactionToDelete = found;
        break;
      }
    }
    if (transactionToDelete == null) {
      return;
    }

    if (!_isDateInCurrentMonthRange(transactionToDelete.date)) {
      return;
    }

    final day = transactionToDelete.date.day;
    final updatedDailyTotals = Map<int, DailyTransactionTotal>.from(
      state.dailyTotals,
    );
    final updatedGroupedTransactions = Map<String, List<Transaction>>.from(
      state.groupedTransactions,
    );

    final dateKey = AppDateUtils.formatDateKey(transactionToDelete.date);
    final dayTransactions = updatedGroupedTransactions[dateKey] ?? []
      ..removeWhere((t) => t.id == transactionId);

    if (dayTransactions.isEmpty) {
      updatedGroupedTransactions.remove(dateKey);
      updatedDailyTotals.remove(day);
    } else {
      updatedGroupedTransactions[dateKey] = dayTransactions;

      double income = 0;
      double expense = 0;
      double transfer = 0;

      for (final t in dayTransactions) {
        if (t.transactionType == TransactionType.income.typeIndex) {
          income += t.amount;
        } else if (t.transactionType == TransactionType.expense.typeIndex) {
          expense += t.amount;
        } else if (t.transactionType == TransactionType.transfer.typeIndex) {
          transfer += t.amount;
        }
      }

      updatedDailyTotals[day] = DailyTransactionTotal(
        income: income,
        expense: expense,
        transfer: transfer,
      );
    }

    emit(
      state.copyWith(
        dailyTotals: updatedDailyTotals,
        groupedTransactions: updatedGroupedTransactions,
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
    add(LoadMonthData(year: year, month: month));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
