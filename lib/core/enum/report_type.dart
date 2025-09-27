import '../constant/exports.dart';

enum ReportType {
  analysis(0, TextConstants.analysisReportTitle),
  account(1, TextConstants.accountReportTitle);

  const ReportType(this.typeIndex, this.displayName);

  final int typeIndex;
  final String displayName;

  static ReportType fromIndex(int index) {
    return ReportType.values.firstWhere(
      (type) => type.typeIndex == index,
      orElse: () => ReportType.analysis,
    );
  }

  static const int totalTypes = 2;
}
