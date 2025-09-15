import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/core/converters/color_converter.dart';
import 'package:kmonie/core/converters/icon_data_converter.dart';

part 'transaction_category.freezed.dart';
part 'transaction_category.g.dart';

@freezed
class TransactionCategory with _$TransactionCategory {
  const factory TransactionCategory({
    required String id,
    required String name,
    @IconDataConverter() required IconData icon,
    @ColorConverter() required Color color,
    @Default('') String description,
  }) = _TransactionCategory;

  factory TransactionCategory.fromJson(Map<String, dynamic> json) =>
      _$TransactionCategoryFromJson(json);
}

extension TransactionCategoryJson on TransactionCategory {
  Map<String, dynamic> toJsonWithIconAndColor() => {
    'id': id,
    'name': name,
    'iconCodePoint': icon.codePoint,
    'iconFontFamily': icon.fontFamily,
    'iconFontPackage': icon.fontPackage,
    'colorValue': color.toARGB32(),
    'description': description,
  };
}

class TransactionCategoryHelper {
  static TransactionCategory fromJsonWithIconAndColor(
    Map<String, dynamic> json,
  ) {
    return TransactionCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: IconData(
        json['iconCodePoint'] as int,
        fontFamily: json['iconFontFamily'] as String?,
        fontPackage: json['iconFontPackage'] as String?,
      ),
      color: Color(json['colorValue'] as int),
      description: json['description'] as String? ?? '',
    );
  }
}
