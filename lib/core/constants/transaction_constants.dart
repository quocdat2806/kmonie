import 'package:kmonie/core/enums/transaction_type.dart';

class TransactionConstants {
  TransactionConstants._();

  static const List<TransactionType> transactionTypes = TransactionType.values;
  static const int totalTransactionTypes = TransactionType.totalTypes;

  static const TransactionType defaultTransactionType = TransactionType.expense;

  // Removed categoryColors; UI now uses a unified color scheme per selection state.
}
