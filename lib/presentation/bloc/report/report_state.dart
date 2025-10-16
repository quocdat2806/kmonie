import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/utils/utils.dart';

part 'report_state.freezed.dart';

@freezed
abstract class ReportState with _$ReportState {
  const factory ReportState({@Default(false) bool isLoading, DateTime? period, @Default({}) Map<int, int> budgetsByCategory, @Default({}) Map<int, int> spentByCategory, @Default(0) int monthlyBudget, String? message, @Default(0) int selectedTabIndex, @Default([]) List<Transaction> transactions}) = _ReportState;

  const ReportState._();

  double get totalIncome => TransactionCalculator.calculateIncome(transactions);
  double get totalExpense => TransactionCalculator.calculateExpense(transactions);
  double get totalTransfer => TransactionCalculator.calculateTransfer(transactions);
  double get totalBalance => TransactionCalculator.calculateBalance(transactions);
}
