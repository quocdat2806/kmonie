import '../enum/exports.dart';


class ReportConstants {
  ReportConstants._();

  static const List<ReportType> reportTypes = ReportType.values;
  static const int totalReportTypes = ReportType.totalTypes;
  static const ReportType defaultReportType = ReportType.analysis;
}
