import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/enum/exports.dart';

part 'search_event.freezed.dart';

@freezed
abstract class SearchEvent with _$SearchEvent {
  const factory SearchEvent.queryChanged(String value) = QueryChanged;
  const factory SearchEvent.typeChanged(TransactionType? type) = TypeChanged;
  const factory SearchEvent.reset() = Reset;
  const factory SearchEvent.apply() = Apply;
}
