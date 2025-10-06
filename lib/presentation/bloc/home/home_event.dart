import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entity/export.dart';

part 'home_event.freezed.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.loadTransactions() = LoadTransactions;
  const factory HomeEvent.changeDate(DateTime date) = ChangeDate;
  const factory HomeEvent.loadMore() = LoadMore;
  const factory HomeEvent.deleteTransaction(int transactionId) = DeleteTransaction;
  const factory HomeEvent.insertTransaction(Transaction transaction) = InsertTransaction;
  const factory HomeEvent.updateTransaction(Transaction transaction) = UpdateTransaction;
}
