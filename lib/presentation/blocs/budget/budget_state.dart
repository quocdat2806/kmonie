import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';

part 'budget_state.freezed.dart';

@freezed
abstract class BudgetState with _$BudgetState {
  const factory BudgetState({
    @Default([]) List<TransactionCategory> expenseCategories,
    @Default({}) Map<int, int> categoryBudgets,
    @Default(0) int monthlyBudget,
    @Default(0) int totalSpent,
    @Default({}) Map<int, int> categorySpent,
    DateTime? period,
  }) = _BudgetState;
}
