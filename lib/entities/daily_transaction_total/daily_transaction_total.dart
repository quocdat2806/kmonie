import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_transaction_total.freezed.dart';
part 'daily_transaction_total.g.dart';

@freezed
abstract class DailyTransactionTotal with _$DailyTransactionTotal {
  const factory DailyTransactionTotal({
    @Default(0.0) double income,
    @Default(0.0) double expense,
    @Default(0.0) double transfer,
  }) = _DailyTransactionTotal;

  factory DailyTransactionTotal.fromJson(Map<String, dynamic> json) =>
      _$DailyTransactionTotalFromJson(json);
}
