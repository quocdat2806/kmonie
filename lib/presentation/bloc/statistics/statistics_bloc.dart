import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/entities/entities.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final TransactionService transactionService;
  final TransactionCategoryService categoryService;

  StatisticsBloc(this.transactionService, this.categoryService) : super(const StatisticsState()) {
    on<StatisticsLoadData>(_onLoadData);
  }

  Future<void> _onLoadData(StatisticsLoadData event, Emitter<StatisticsState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Load all transactions
      final transactions = await transactionService.getAllTransactions();

      // Load all categories
      final allCategories = await categoryService.getAll();
      final categoriesMap = {for (final cat in allCategories) cat.id!: cat};

      // Filter transactions by type
      final filteredTransactions = _filterTransactionsByType(transactions, event.transactionType, categoriesMap);

      // Group by date
      final groupedTransactions = _groupTransactionsByDate(filteredTransactions);

      // Calculate statistics
      final totalAmount = _calculateTotalAmount(filteredTransactions);
      final transactionCount = filteredTransactions.length;

      emit(state.copyWith(isLoading: false, groupedTransactions: groupedTransactions, categoriesMap: categoriesMap, totalAmount: totalAmount, transactionCount: transactionCount, transactionType: event.transactionType));
    } catch (error) {
      emit(state.copyWith(isLoading: false, message: 'Lỗi tải dữ liệu thống kê: $error'));
    }
  }

  /// Filter transactions by type
  List<Transaction> _filterTransactionsByType(List<Transaction> transactions, TransactionType type, Map<int, TransactionCategory> categoriesMap) {
    return transactions.where((transaction) {
      final category = categoriesMap[transaction.transactionCategoryId];
      return category?.transactionType == type;
    }).toList();
  }

  /// Group transactions by date
  Map<String, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final Map<String, List<Transaction>> grouped = {};

    for (final transaction in transactions) {
      final dateKey = _formatDateKey(transaction.date);
      grouped.putIfAbsent(dateKey, () => []).add(transaction);
    }

    // Sort by date descending
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    final Map<String, List<Transaction>> sortedGrouped = {};
    for (final key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }

  /// Calculate total amount
  double _calculateTotalAmount(List<Transaction> transactions) {
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  /// Format date key
  String _formatDateKey(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
