import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../entity/exports.dart';
import '../../../core/enum/exports.dart';

part 'search_state.freezed.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default('') String query,
    TransactionType? selectedType,
    @Default(<Transaction>[]) List<Transaction> results,
    @Default(<Transaction>[]) List<Transaction> all,
    @Default(false) bool isLoading,
  }) = _SearchState;
}
