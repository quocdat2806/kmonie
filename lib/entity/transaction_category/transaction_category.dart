import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/enum/transaction_type.dart';
part 'transaction_category.freezed.dart';
part 'transaction_category.g.dart';

@freezed
abstract class TransactionCategory with _$TransactionCategory {
  const factory TransactionCategory({
    @Default(null) int? id,
    required String title,
    @Default('') String pathAsset,
    @Default(0) int transactionType,
    @Default(true) bool isCategoryDefaultSystem,
  }) = _TransactionCategory;

  factory TransactionCategory.fromJson(Map<String, dynamic> json) =>
      _$TransactionCategoryFromJson(json);
}
