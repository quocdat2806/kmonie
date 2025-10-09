import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entity/export.dart';

part 'home_event.freezed.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.loadTransactions() = HomeLoadTransactions;
  const factory HomeEvent.changeDate(DateTime date) = HomeChangeDate;
  const factory HomeEvent.loadMore() = HomeLoadMore;
  const factory HomeEvent.deleteTransaction(int transactionId) = HomeDeleteTransaction;
  const factory HomeEvent.insertTransaction(Transaction transaction) = HomeInsertTransaction;
  const factory HomeEvent.updateTransaction(Transaction transaction) = HomeUpdateTransaction;
}
