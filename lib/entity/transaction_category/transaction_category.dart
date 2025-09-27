import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/enum/exports.dart';
part 'transaction_category.freezed.dart';
part 'transaction_category.g.dart';

@freezed
abstract class TransactionCategory with _$TransactionCategory {
  const factory TransactionCategory({
    int? id,
    required String title,
    @Default('') String pathAsset,
    @Default(TransactionType.expense) TransactionType transactionType,
    @Default(true) bool isCategoryDefaultSystem,
  }) = _TransactionCategory;

  factory TransactionCategory.fromJson(Map<String, dynamic> json) =>
      _$TransactionCategoryFromJson(json);
}
