import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_statistics_event.freezed.dart';

@freezed
abstract class MonthlyStatisticsEvent with _$MonthlyStatisticsEvent {
  const factory MonthlyStatisticsEvent.load({int? year}) = LoadMonthlyStatistics;
}
