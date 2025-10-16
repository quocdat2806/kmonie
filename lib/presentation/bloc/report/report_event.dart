import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_event.freezed.dart';

@freezed
abstract class ReportEvent with _$ReportEvent {
  const factory ReportEvent.init({required DateTime period}) = ReportInit;
  const factory ReportEvent.changePeriod({required DateTime period}) = ReportChangePeriod;
  const factory ReportEvent.setBudget({required DateTime period, required int categoryId, required int amount}) = ReportSetBudget;
  const factory ReportEvent.changeTab({required int index}) = ReportChangeTab;
}
