import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_category.freezed.dart';
part 'transaction_category.g.dart';

@freezed
class TransactionCategory with _$TransactionCategory {
  const factory TransactionCategory({
    required String id,
    required String title,
    @Default('') String image,
  }) = _TransactionCategory;

  factory TransactionCategory.fromJson(Map<String, dynamic> json) =>
      _$TransactionCategoryFromJson(json);
}
