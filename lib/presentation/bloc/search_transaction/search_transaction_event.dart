import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/enum/export.dart';
import '../../../entity/export.dart';

part 'search_transaction_event.freezed.dart';

@freezed
 class SearchTransactionEvent with _$SearchTransactionEvent {
  const factory SearchTransactionEvent.queryChanged(String value) = SearchTransactionQueryChanged;
  const factory SearchTransactionEvent.typeChanged(TransactionType? type) = SearchTransactionTypeChanged;
  const factory SearchTransactionEvent.reset() = SearchTransactionReset;
  const factory SearchTransactionEvent.apply() = SearchTransactionApply;
  const factory SearchTransactionEvent.updateTransaction(Transaction transaction) = SearchTransactionUpdateTransaction;
  const factory SearchTransactionEvent.deleteTransaction(int id) = SearchTransactionDeleteTransaction;


}
