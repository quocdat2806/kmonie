import 'transaction_category.dart';

class SeparatedCategories {
  final List<TransactionCategory> expense;
  final List<TransactionCategory> income;

  const SeparatedCategories({
    required this.expense,
    required this.income,
  });
}
