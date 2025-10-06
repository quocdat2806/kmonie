import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.freezed.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.loadTransactions() = LoadTransactions;
  const factory HomeEvent.refreshTransactions() = RefreshTransactions;
  const factory HomeEvent.changeDate(DateTime date) = ChangeDate;
  const factory HomeEvent.loadMore() = LoadMore;
  const factory HomeEvent.deleteTransaction(int transactionId) = DeleteTransaction;
  const factory HomeEvent.updateTransaction(int transactionId) = UpdateTransaction;
}
