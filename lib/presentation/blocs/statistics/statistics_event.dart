import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/core/enums/enums.dart';

part 'statistics_event.freezed.dart';

@freezed
abstract class StatisticsEvent with _$StatisticsEvent {
  const factory StatisticsEvent.loadData(TransactionType transactionType) =
      StatisticsLoadData;
}
