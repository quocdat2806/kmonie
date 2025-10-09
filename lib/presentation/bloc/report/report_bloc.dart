import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/service/budget.dart';
import '../../../core/service/transaction.dart';
import '../../../core/service/transaction_category.dart';
import '../../../core/enum/export.dart';
import '../../../core/util/date.dart';
import '../../../entity/export.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final BudgetService budgetService;
  final TransactionService transactionService;
  final TransactionCategoryService categoryService;
  StreamSubscription<List<Transaction>>? _txSub;

  ReportBloc(this.budgetService, this.transactionService, this.categoryService) : super(const ReportState()) {
    on<ReportInit>(_onInit);
    on<ReportChangePeriod>(_onChangePeriod);
    on<ReportSetBudget>(_onSetBudget);

    _txSub = transactionService.watchTransactions().listen((_) {
      final int y = state.period!.year;
      final int m = state.period!.month;
      if (y > 0 && m > 0) {
        final p = DateTime(y, m);
        add(ReportChangePeriod(period: p));
      }
    });
  }

  Future<void> _load(DateTime period, Emitter<ReportState> emit) async {
    final p = DateTime(period.year, period.month);
    emit(state.copyWith(isLoading: true, period: p));
    try {
      final budgets = await budgetService.getBudgetsForMonth(p.year, p.month);

      final range = AppDateUtils.monthRangeUtc(p.year, p.month);
      final all = await transactionService.getAllTransactions();
      final startLocal = range.startUtc.toLocal();
      final endLocal = range.endUtc.toLocal();
      // include start of month (>= start) and exclude end (before end)
      final inMonth = all.where((t) => !t.date.isBefore(startLocal) && t.date.isBefore(endLocal)).toList();

      // only expense
      final categories = await categoryService.getAll();
      final expenseIds = categories.where((c) => c.transactionType == TransactionType.expense).map((c) => c.id!).toSet();

      final Map<int, int> spent = {};
      for (final Transaction tx in inMonth) {
        if (!expenseIds.contains(tx.transactionCategoryId)) continue;
        final current = spent[tx.transactionCategoryId] ?? 0;
        spent[tx.transactionCategoryId] = current + tx.amount;
      }

      emit(state.copyWith(isLoading: false, budgetsByCategory: budgets, spentByCategory: spent, message: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: 'Lỗi tải báo cáo: $e'));
    }
  }

  Future<void> _onInit(ReportInit event, Emitter<ReportState> emit) async {
    await _load(event.period, emit);
  }

  Future<void> _onChangePeriod(ReportChangePeriod event, Emitter<ReportState> emit) async {
    await _load(event.period, emit);
  }

  Future<void> _onSetBudget(ReportSetBudget event, Emitter<ReportState> emit) async {
    await budgetService.setBudgetForCategory(year: event.period.year, month: event.period.month, categoryId: event.categoryId, amount: event.amount);
    await _load(event.period, emit);
  }

  @override
  Future<void> close() async {
    await _txSub?.cancel();
    return super.close();
  }
}
