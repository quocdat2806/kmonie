import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/enum/exports.dart';

part 'home_event.freezed.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.loadTransactions() = HomeLoadTransactions;
  const factory HomeEvent.refreshTransactions() = HomeRefreshTransactions;
  const factory HomeEvent.filterByType(TransactionType? type) =
      HomeFilterByType;
  const factory HomeEvent.changeDate(DateTime date) = HomeChangeDate;
  const factory HomeEvent.loadTransactionsByMonthYear({
    required int year,
    required int month,
  }) = HomeLoadTransactionsByMonthYear;
}
