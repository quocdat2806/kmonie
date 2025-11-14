import 'transaction.dart';

class PagedTransactionResult {
  final List<Transaction> transactions;
  final int totalRecords;

  PagedTransactionResult({
    required this.transactions,
    required this.totalRecords,
  });
}
