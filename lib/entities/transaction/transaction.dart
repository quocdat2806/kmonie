import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({int? id, required int amount, required DateTime date, required int transactionCategoryId, @Default('') String content, @Default(0) int transactionType, DateTime? createdAt, DateTime? updatedAt}) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}
