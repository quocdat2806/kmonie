import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';

part 'calendar_monthly_transaction_event.freezed.dart';

@freezed
abstract class CalendarMonthlyTransactionEvent with _$CalendarMonthlyTransactionEvent {
  const factory CalendarMonthlyTransactionEvent.loadMonthData({int? year, int? month}) = LoadMonthData;

  const factory CalendarMonthlyTransactionEvent.changeSelectedDate(DateTime date) = ChangeSelectedDate;

  const factory CalendarMonthlyTransactionEvent.insertTransaction(Transaction transaction) = CalendarMonthlyTransactionInsertTransaction;

  const factory CalendarMonthlyTransactionEvent.updateTransaction(Transaction transaction) = CalendarMonthlyTransactionUpdateTransaction;

  const factory CalendarMonthlyTransactionEvent.deleteTransaction(int id) = CalendarMonthlyTransactionDeleteTransaction;

  const factory CalendarMonthlyTransactionEvent.changeMonthYear({int? year, int? month}) = ChangeMonthYear;
}
