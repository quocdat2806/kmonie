import 'transaction_category.dart';

class SeparatedCategories {
  final List<TransactionCategory> expense;
  final List<TransactionCategory> income;
  final List<TransactionCategory> transfer;

  const SeparatedCategories({
    required this.expense,
    required this.income,
    required this.transfer,
  });
}
