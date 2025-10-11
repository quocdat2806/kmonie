import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
abstract class Account with _$Account {
  const factory Account({int? id, required String name, @Default('Mặc định') String type, @Default('VND') String currency, @Default(0) int amount, @Default('') String iconPath, @Default('') String notes}) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}
