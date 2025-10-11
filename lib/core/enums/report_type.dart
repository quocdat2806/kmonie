import 'package:kmonie/core/constants/constants.dart';

enum ReportType {
  analysis(0, AppTextConstants.analysis),
  account(1, AppTextConstants.account);

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

extension ExReportType on ReportType {
  static List<ReportType> reportTypes = ReportType.values;
  static List<String> reportTypeNames = reportTypes
      .map((e) => e.displayName)
      .toList();
}
