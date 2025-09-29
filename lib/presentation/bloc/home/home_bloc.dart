import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/service/exports.dart';
import '../../../core/stream/export.dart';
import '../../../core/enum/exports.dart';
import '../../../core/util/exports.dart';
import '../../../entity/exports.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TransactionService transactionService;
  final TransactionCategoryService categoryService;
  StreamSubscription<AppEvent>? _refreshSubscription;

  HomeBloc(this.transactionService, this.categoryService)
    : super(const HomeState()) {
    on<HomeLoadTransactions>(_onLoadTransactions);
    on<HomeRefreshTransactions>(_onRefreshTransactions);
    on<HomeFilterByType>(_onFilterByType);
    on<HomeChangeDate>(_onChangeDate);
    on<HomeLoadTransactionsByMonthYear>(_onLoadTransactionsByMonthYear);
    _refreshSubscription = AppStreamEvent.eventStreamStatic.listen((event) {
      if (event == AppEvent.refreshHomeData) {
        add(const HomeRefreshTransactions());
      }
    });
  }

  Future<void> _onLoadTransactions(
    HomeLoadTransactions event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentDate = state.selectedDate ?? DateTime.now();
      final transactions = await transactionService.getTransactionsByMonthYear(
        year: currentDate.year,
        month: currentDate.month,
      );
      final groupedTransactions = _groupTransactionsByDate(transactions);

      // Load all categories
      final allCategories = await categoryService.getAll();
      final categoriesMap = {for (var cat in allCategories) cat.id!: cat};

      emit(
        state.copyWith(
          groupedTransactions: groupedTransactions,
          transactions: transactions,
          categoriesMap: categoriesMap,
        ),
      );
    } catch (error) {
      logger.e('HomeBloc: Error in load transactions: $error');
    }
  }

  Future<void> _onRefreshTransactions(
    HomeRefreshTransactions event,
    Emitter<HomeState> emit,
  ) async {
    logger.d('HomeBloc: _onRefreshTransactions called');
    try {
      final lastTransaction = await transactionService.getLastTransaction();
      logger.d('HomeBloc: Last transaction: ${lastTransaction?.id}');

      if (lastTransaction != null) {
        final existingTransaction = state.transactions.firstWhere(
          (t) => t.id == lastTransaction.id,
          orElse: () => Transaction(
            id: -1,
            amount: 0,
            date: DateTime.now(),
            transactionCategoryId: 0,
          ),
        );

        logger.d(
          'HomeBloc: Existing transaction found: ${existingTransaction.id}',
        );

        if (existingTransaction.id == -1) {
          logger.d('HomeBloc: Adding new transaction to list');
          final updatedTransactions = [lastTransaction, ...state.transactions];
          final groupedTransactions = _groupTransactionsByDate(
            updatedTransactions,
          );

          emit(
            state.copyWith(
              transactions: updatedTransactions,
              groupedTransactions: groupedTransactions,
            ),
          );
        } else {
          logger.d('HomeBloc: Transaction already exists, no update needed');
        }
      }
    } catch (error) {
      logger.e('HomeBloc: Error in refresh: $error');
      add(const HomeLoadTransactions());
    }
  }

  void _onFilterByType(HomeFilterByType event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedType: event.type));

    // Filter transactions based on selected type
    final filteredTransactions = _filterTransactionsByType(
      state.transactions,
      event.type,
    );

    final groupedTransactions = _groupTransactionsByDate(filteredTransactions);

    emit(state.copyWith(groupedTransactions: groupedTransactions));
  }

  Future<void> _onChangeDate(
    HomeChangeDate event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(selectedDate: event.date));

    // Load transactions cho tháng/năm mới
    add(
      HomeEvent.loadTransactionsByMonthYear(
        year: event.date.year,
        month: event.date.month,
      ),
    );
  }

  Future<void> _onLoadTransactionsByMonthYear(
    HomeLoadTransactionsByMonthYear event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final transactions = await transactionService.getTransactionsByMonthYear(
        year: event.year,
        month: event.month,
      );
      final groupedTransactions = _groupTransactionsByDate(transactions);

      emit(
        state.copyWith(
          groupedTransactions: groupedTransactions,
          transactions: transactions,
        ),
      );
    } catch (error) {
      logger.e('HomeBloc: Error in load transactions by month year: $error');
    }
  }

  /// Nhóm giao dịch theo ngày
  Map<String, List<Transaction>> _groupTransactionsByDate(
    List<Transaction> transactions,
  ) {
    final Map<String, List<Transaction>> grouped = {};

    for (final transaction in transactions) {
      final dateKey = _formatDateKey(transaction.date);
      grouped.putIfAbsent(dateKey, () => []).add(transaction);
    }

    // Sắp xếp theo ngày giảm dần
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    final Map<String, List<Transaction>> sortedGrouped = {};
    for (final key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }

  /// Format ngày thành key để nhóm
  String _formatDateKey(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Filter transactions by type
  List<Transaction> _filterTransactionsByType(
    List<Transaction> transactions,
    TransactionType? type,
  ) {
    if (type == null) return transactions;

    return transactions.where((transaction) {
      final category = state.categoriesMap[transaction.transactionCategoryId];
      return category?.transactionType == type;
    }).toList();
  }

  @override
  Future<void> close() {
    _refreshSubscription?.cancel();
    return super.close();
  }
}
