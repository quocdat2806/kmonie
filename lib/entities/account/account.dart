import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
abstract class Account with _$Account {
  const factory Account({int? id, required String name, @Default('Tiết kiệm') String type, @Default(0) int amount, @Default(0) int balance, @Default('') String accountNumber, int? bankId, @Default(false) bool isPinned}) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}
