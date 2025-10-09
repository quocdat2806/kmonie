// calendar_monthly_transaction_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/enum/transaction_type.dart';
import '../../../core/stream/export.dart';
import '../../../core/util/export.dart';
import '../../../core/enum/app_event.dart';
import '../../../core/service/export.dart';
import '../../../entity/export.dart';
import 'calendar_monthly_transaction_event.dart';
import 'calendar_monthly_transaction_state.dart';

class CalendarMonthlyTransactionBloc extends Bloc<CalendarMonthlyTransactionEvent, CalendarMonthTransactionState> {
  final TransactionService transactionService;
  final TransactionCategoryService categoryService;

  StreamSubscription<AppStreamData>? _sub;

  CalendarMonthlyTransactionBloc(this.transactionService, this.categoryService) : super(CalendarMonthTransactionState(selectedDate: DateTime.now())) {
    on<LoadMonthData>(_onLoadMonthData);
    on<ChangeSelectedDate>(_onChangeSelectedDate);
    on<CalendarMonthlyTransactionInsertTransaction>(_onInsertTransaction);
    on<CalendarMonthlyTransactionUpdateTransaction>(_onUpdateTransaction);
    on<CalendarMonthlyTransactionDeleteTransaction>(_onDeleteTransaction);
    on<ChangeMonthYear>(_onChangeMonthYear);

    // 👂 Lắng nghe stream từ nơi khác (thêm/sửa/xóa giao dịch)
    _sub = AppStreamEvent.eventStreamStatic.listen((data) {
      switch (data.event) {
        case AppEvent.insertTransaction:
          add(CalendarMonthlyTransactionInsertTransaction(data.payload as Transaction));
          break;
        case AppEvent.updateTransaction:
          add(CalendarMonthlyTransactionUpdateTransaction(data.payload as Transaction));
          break;
        case AppEvent.deleteTransaction:
          add(CalendarMonthlyTransactionDeleteTransaction(data.payload as int));
          break;
      }
    });

    // Load dữ liệu ban đầu
    final now = DateTime.now();
    add(LoadMonthData(year: now.year, month: now.month));
  }

  Future<void> _onLoadMonthData(LoadMonthData event, Emitter<CalendarMonthTransactionState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      // 📝 1️⃣ Lấy toàn bộ giao dịch trong tháng
      final allTransactions = await transactionService.getTransactionsInMonth(year: event.year, month: event.month, pageSize: 9999);

      // 📝 2️⃣ Gom nhóm theo ngày (dd/MM/yyyy)
      final grouped = transactionService.groupByDate(allTransactions.transactions);

      // 📝 3️⃣ Lấy category map
      final categories = await categoryService.getAll();
      final categoriesMap = {for (final c in categories) c.id!: c};

      // 📝 4️⃣ Tính dailyTotals (giống HomeBloc)
      final dailyTotals = <int, DailyTransactionTotal>{};

      for (final entry in grouped.entries) {
        // ⚠️ entry.key có dạng "06/10/2025" => cần parse thủ công
        final parts = entry.key.split('/');
        if (parts.length != 3) {
          logger.e('Invalid date key format: ${entry.key}');
          continue;
        }

        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final date = DateTime(year, month, day);

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

        dailyTotals[date.day] = DailyTransactionTotal(income: income, expense: expense, transfer: transfer);
      }

      // 📝 5️⃣ Cập nhật state
      emit(state.copyWith(isLoading: false, groupedTransactions: grouped, dailyTotals: dailyTotals, categoriesMap: categoriesMap, selectedDate: DateTime(event.year, event.month, state.selectedDate.day)));
    } catch (e) {
      logger.e('❤️ ERROR: CalendarBloc error: $e');
      emit(state.copyWith(isLoading: false, dailyTotals: {}));
    }
  }

  void _onChangeSelectedDate(ChangeSelectedDate event, Emitter<CalendarMonthTransactionState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onInsertTransaction(CalendarMonthlyTransactionInsertTransaction event, Emitter<CalendarMonthTransactionState> emit) {
    final tx = event.transaction;
    final day = tx.date.day;
    final existing = state.dailyTotals[day] ?? const DailyTransactionTotal();
    final updatedDailyTotals = Map<int, DailyTransactionTotal>.from(state.dailyTotals);
    final updatedGroupedTransactions = Map<String, List<Transaction>>.from(state.groupedTransactions);

    // Update daily totals
    if (tx.transactionType == 1) {
      updatedDailyTotals[day] = existing.copyWith(income: existing.income + tx.amount);
    } else if (tx.transactionType == 0) {
      updatedDailyTotals[day] = existing.copyWith(expense: existing.expense + tx.amount);
    } else if (tx.transactionType == 2) {
      updatedDailyTotals[day] = existing.copyWith(transfer: existing.transfer + tx.amount);
    }

    // Update grouped transactions
    final dateKey = AppDateUtils.formatDateKey(tx.date);
    final existingTransactions = updatedGroupedTransactions[dateKey] ?? [];
    if (!existingTransactions.any((e) => e.id == tx.id)) {
      existingTransactions.insert(0, tx);
      updatedGroupedTransactions[dateKey] = existingTransactions;
    }

    emit(state.copyWith(dailyTotals: updatedDailyTotals, groupedTransactions: updatedGroupedTransactions));
  }

  void _onUpdateTransaction(CalendarMonthlyTransactionUpdateTransaction event, Emitter<CalendarMonthTransactionState> emit) {
    final date = event.transaction.date;
    add(LoadMonthData(year: date.year, month: date.month));
  }

  void _onDeleteTransaction(CalendarMonthlyTransactionDeleteTransaction event, Emitter<CalendarMonthTransactionState> emit) {
    final now = state.selectedDate;
    add(LoadMonthData(year: now.year, month: now.month));
  }

  void _onChangeMonthYear(ChangeMonthYear event, Emitter<CalendarMonthTransactionState> emit) {
    add(LoadMonthData(year: event.year, month: event.month));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
