import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/bank/bank.dart';

part 'account.freezed.dart';
part 'account.g.dart';

class BankInfoConverter implements JsonConverter<Bank?, Map<String, dynamic>?> {
  const BankInfoConverter();

  @override
  Bank? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Bank.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(Bank? bank) {
    return bank?.toJson();
  }
}

@freezed
abstract class Account with _$Account {
  const factory Account({int? id, required String name, @Default('Tiết kiệm') String type, @Default(0) int amount, @Default(0) int balance, @Default('') String accountNumber, @BankInfoConverter() Bank? bank, @Default(false) bool isPinned}) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}
