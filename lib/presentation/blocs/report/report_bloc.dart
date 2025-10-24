import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/services/budget.dart';
import 'package:kmonie/core/services/transaction.dart';
import 'package:kmonie/core/services/transaction_category.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final BudgetService budgetService;
  final TransactionService transactionService;
  final TransactionCategoryService categoryService;
  final AccountRepository accountRepository;
  StreamSubscription<List<Transaction>>? _txSub;
  StreamSubscription<AppStreamData>? _budgetSub;
  StreamSubscription<List<Account>>? _accountsSub;

  ReportBloc(this.budgetService, this.transactionService, this.categoryService, this.accountRepository) : super(const ReportState()) {
    on<ReportInit>(_onInit);
    on<ReportChangePeriod>(_onChangePeriod);
    on<ReportSetBudget>(_onSetBudget);
    on<ReportChangeTab>(_onChangeTab);

    _txSub = transactionService.watchTransactions().listen((_) {
      final int y = state.period!.year;
      final int m = state.period!.month;
      if (y > 0 && m > 0) {
        final p = DateTime(y, m);
        add(ReportChangePeriod(period: p));
      }
    });

    _budgetSub = AppStreamEvent.eventStreamStatic.listen((data) {
      if (data.event == AppEvent.budgetChanged) {
        final p = state.period ?? DateTime.now();
        add(ReportChangePeriod(period: DateTime(p.year, p.month)));
      }
    });
  }

  Future<void> _load(DateTime period, Emitter<ReportState> emit) async {
    final p = DateTime(period.year, period.month);

    // Debug month range
    final range = AppDateUtils.monthRangeUtc(p.year, p.month);

    emit(state.copyWith(isLoading: true, period: p));
    try {
      final budgets = await budgetService.getBudgetsForMonth(p.year, p.month);
      final monthlyBudget = await budgetService.getMonthlyBudget(year: p.year, month: p.month);

      final all = await transactionService.getAllTransactions();
      final startLocal = range.startUtc.toLocal();
      final endLocal = range.endUtc.toLocal();
      final inMonth = all.where((t) => !t.date.isBefore(startLocal) && t.date.isBefore(endLocal)).toList();

      final categories = await categoryService.getAll();
      final expenseIds = categories.where((c) => c.transactionType == TransactionType.expense).map((c) => c.id!).toSet();

      final Map<int, int> spent = {};
      for (final Transaction tx in inMonth) {
        if (!expenseIds.contains(tx.transactionCategoryId)) continue;
        final current = spent[tx.transactionCategoryId] ?? 0;
        spent[tx.transactionCategoryId] = current + tx.amount;
      }

      final accountsResult = await accountRepository.getAllAccounts();
      final accounts = accountsResult.fold((failure) => <Account>[], (accounts) => accounts);

      emit(state.copyWith(isLoading: false, budgetsByCategory: budgets, spentByCategory: spent, monthlyBudget: monthlyBudget, transactions: inMonth, accounts: accounts, message: null));
    } catch (e) {
      logger.e('ReportBloc: Error loading data: $e');
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

  void _onChangeTab(ReportChangeTab event, Emitter<ReportState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  @override
  Future<void> close() async {
    await _txSub?.cancel();
    await _budgetSub?.cancel();
    await _accountsSub?.cancel();
    return super.close();
  }
}
