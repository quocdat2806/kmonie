import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kmonie/entity/entity.dart';

part 'add_budget_state.freezed.dart';

@freezed
abstract class AddBudgetState with _$AddBudgetState {
  const factory AddBudgetState({@Default([]) List<TransactionCategory> expenseCategories, @Default({}) Map<String, int> budgets}) = _AddBudgetState;
}
