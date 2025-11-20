import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final BudgetRepository budgetRepository;
  final TransactionRepository transactionRepository;
  final TransactionCategoryRepository categoryRepository;
  final AccountRepository accountRepository;
  StreamSubscription<AppStreamData>? _budgetSub;
  StreamSubscription<AppStreamData>? _transactionSub;

  ReportBloc(this.budgetRepository, this.transactionRepository, this.categoryRepository, this.accountRepository) : super(const ReportState()) {
    on<ReportInit>(_onInit);
    on<ReportChangePeriod>(_onChangePeriod);
    on<ReportSetBudget>(_onSetBudget);
    on<ReportChangeTab>(_onChangeTab);

    _budgetSub = AppStreamEvent.eventStreamStatic.listen((data) {
      if (data.event == AppEvent.budgetChanged) {
        final p = state.period ?? DateTime.now();
        add(ReportChangePeriod(period: DateTime(p.year, p.month)));
      } else if (data.event == AppEvent.accountChanged) {
        final p = state.period ?? DateTime.now();
        add(ReportChangePeriod(period: DateTime(p.year, p.month)));
      } else if (data.event == AppEvent.deleteAllData) {
        final p = state.period ?? DateTime.now();
        add(ReportChangePeriod(period: DateTime(p.year, p.month)));
      }
    });

    _transactionSub = AppStreamEvent.eventStreamStatic.listen((data) {
      final currentPeriod = state.period ?? DateTime.now();
      switch (data.event) {
        case AppEvent.insertTransaction:
          if (data.payload is Transaction) {
            final tx = data.payload as Transaction;
            if (_isTransactionInPeriod(tx, currentPeriod)) {
              add(ReportChangePeriod(period: DateTime(currentPeriod.year, currentPeriod.month)));
            }
          }
          break;
        case AppEvent.updateTransaction:
          if (data.payload is Transaction) {
            final tx = data.payload as Transaction;
            if (_isTransactionInPeriod(tx, currentPeriod)) {
              add(ReportChangePeriod(period: DateTime(currentPeriod.year, currentPeriod.month)));
            }
          }
          break;
        case AppEvent.deleteTransaction:
          add(ReportChangePeriod(period: DateTime(currentPeriod.year, currentPeriod.month)));
          break;
        case AppEvent.deleteAllData:
          add(ReportChangePeriod(period: DateTime(currentPeriod.year, currentPeriod.month)));
          break;
        default:
          break;
      }
    });

    add(ReportEvent.init(period: DateTime.now()));
  }

  bool _isTransactionInPeriod(Transaction transaction, DateTime period) {
    return AppDateUtils.isDateInCurrentMonth(transaction.date, period);
  }

  Future<void> _load(DateTime period, Emitter<ReportState> emit) async {
    final p = DateTime(period.year, period.month);
    final range = AppDateUtils.monthRangeUtc(p.year, p.month);

    emit(state.copyWith(loadStatus: LoadStatus.loading, period: p));

    try {
      final budgetsResult = await budgetRepository.getBudgetsForMonth(p.year, p.month);
      final budgets = budgetsResult.fold((failure) => <int, int>{}, (budgets) => budgets);

      final monthlyBudgetResult = await budgetRepository.getMonthlyBudget(year: p.year, month: p.month);
      final monthlyBudget = monthlyBudgetResult.fold((failure) => 0, (budget) => budget);

      final transactionsResult = await transactionRepository.getAllTransactions();
      final all = transactionsResult.fold((failure) => <Transaction>[], (transactions) => transactions);

      final startLocal = range.startUtc.toLocal();
      final endLocal = range.endUtc.toLocal();
      final inMonth = all.where((t) => !t.date.isBefore(startLocal) && t.date.isBefore(endLocal)).toList();

      final categoriesResult = await categoryRepository.getAll();
      final categories = categoriesResult.fold((failure) => <TransactionCategory>[], (categories) => categories);
      final expenseIds = categories.where((c) => c.transactionType == TransactionType.expense).map((c) => c.id!).toSet();

      final Map<int, int> spent = {};
      for (final Transaction tx in inMonth) {
        if (!expenseIds.contains(tx.transactionCategoryId)) continue;
        final current = spent[tx.transactionCategoryId] ?? 0;
        spent[tx.transactionCategoryId] = current + tx.amount;
      }

      final accountsResult = await accountRepository.getAllAccounts();
      final accounts = accountsResult.fold((failure) => <Account>[], (accounts) => accounts);

      emit(state.copyWith(loadStatus: LoadStatus.success, budgetsByCategory: budgets, spentByCategory: spent, monthlyBudget: monthlyBudget, transactions: inMonth, accounts: accounts, message: null));
    } catch (e) {
      logger.e('ReportBloc: Error loading data: $e');
      emit(state.copyWith(loadStatus: LoadStatus.error, message: 'Lỗi tải báo cáo: $e'));
    }
  }

  Future<void> _onInit(ReportInit event, Emitter<ReportState> emit) async {
    await _load(event.period, emit);
  }

  Future<void> _onChangePeriod(ReportChangePeriod event, Emitter<ReportState> emit) async {
    await _load(event.period, emit);
  }

  Future<void> _onSetBudget(ReportSetBudget event, Emitter<ReportState> emit) async {
    await budgetRepository.setBudgetForCategory(year: event.period.year, month: event.period.month, categoryId: event.categoryId, amount: event.amount);
    await _load(event.period, emit);
  }

  void _onChangeTab(ReportChangeTab event, Emitter<ReportState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  @override
  Future<void> close() async {
    await _budgetSub?.cancel();
    await _transactionSub?.cancel();
    return super.close();
  }
}
