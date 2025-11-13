import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';

part 'daily_transaction_event.freezed.dart';

@freezed
abstract class DailyTransactionEvent with _$DailyTransactionEvent {
  const factory DailyTransactionEvent.loadDailyTransactions({
    required DateTime selectedDate,
    required Map<String, List<Transaction>> groupedTransactions,
    required Map<int, TransactionCategory> categoriesMap,
  }) = LoadDailyTransactions;

  const factory DailyTransactionEvent.insertTransaction(
    Transaction transaction,
  ) = InsertTransaction;

  const factory DailyTransactionEvent.updateTransaction(
    Transaction transaction,
  ) = UpdateTransaction;

  const factory DailyTransactionEvent.deleteTransaction(int transactionId) =
      DeleteTransaction;
}
