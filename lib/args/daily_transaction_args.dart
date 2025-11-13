import 'package:kmonie/entities/entities.dart';

class DailyTransactionPageArgs {
  final DateTime selectedDate;
  final Map<String, List<Transaction>> groupedTransactions;
  final Map<int, TransactionCategory> categoriesMap;

  const DailyTransactionPageArgs({
    required this.selectedDate,
    required this.groupedTransactions,
    required this.categoriesMap,
  });
}
