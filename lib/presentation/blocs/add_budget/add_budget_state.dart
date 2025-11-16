import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kmonie/entities/entities.dart';

part 'add_budget_state.freezed.dart';

@freezed
abstract class AddBudgetState with _$AddBudgetState {
  const factory AddBudgetState({
    @Default([]) List<TransactionCategory> expenseCategories,
    @Default({}) Map<String, int> budgets,
    @Default(0) int currentInput,
    @Default(0) int monthlyBudget,
    @Default({}) Map<int, int> categoryBudgets,
    int? currentInputIdCategory,
    @Default(false) bool isKeyboardVisible,
  }) = _AddBudgetState;
}
