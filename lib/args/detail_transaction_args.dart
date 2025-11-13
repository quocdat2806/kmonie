import 'package:kmonie/entities/entities.dart';

class DetailTransactionArgs {
  final Transaction transaction;
  final TransactionCategory category;

  DetailTransactionArgs({required this.transaction, required this.category});
}
