import 'package:kmonie/entities/entities.dart';

class AddBudgetArgs {
  final int? monthlyBudget;
  final Map<int, int>? categoryBudgets;
  final List<TransactionCategory> expenseCategories;
  AddBudgetArgs({
    this.monthlyBudget,
    this.categoryBudgets,
    this.expenseCategories = const [],
  });
}
