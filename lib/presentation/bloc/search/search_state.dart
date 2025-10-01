import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/enum/exports.dart';
import '../../../entity/exports.dart';

part 'search_state.freezed.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({@Default('') String query, TransactionType? selectedType, @Default(<Transaction>[]) List<Transaction> results}) = _SearchState;
}
