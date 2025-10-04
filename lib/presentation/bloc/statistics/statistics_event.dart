import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/enum/export.dart';

part 'statistics_event.freezed.dart';

@freezed
abstract class StatisticsEvent with _$StatisticsEvent {
  const factory StatisticsEvent.loadData(TransactionType transactionType) =
      StatisticsLoadData;
}
