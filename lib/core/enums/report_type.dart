enum ReportType {
  analysis(0, 'Phân tích'),
  account(1, 'Tài khoản');

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
