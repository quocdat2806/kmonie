import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/enum/export.dart';
import '../../../entity/export.dart';

part 'search_state.freezed.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default('') String query,
    TransactionType? selectedType,
    @Default(<Transaction>[]) List<Transaction> results,
    @Default({}) Map<String, List<Transaction>> groupedResults,
    @Default({}) Map<int, TransactionCategory> categoriesMap,
  }) = _SearchState;
}
