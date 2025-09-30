import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/enum/exports.dart';

part 'search_event.freezed.dart';

@freezed
abstract class SearchEvent with _$SearchEvent {
  const factory SearchEvent.initialized() = SearchInitialized;
  const factory SearchEvent.queryChanged(String query) = SearchQueryChanged;
  const factory SearchEvent.typeChanged(TransactionType? type) =
      SearchTypeChanged;
  const factory SearchEvent.reset() = SearchReset;
  const factory SearchEvent.apply() = SearchApply;
}
