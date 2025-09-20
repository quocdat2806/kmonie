enum IncomeType {
  month(0, 'Tháng'),
  year(1, 'Năm');

  const IncomeType(this.typeIndex, this.displayName);

  final int typeIndex;
  final String displayName;

  static IncomeType fromIndex(int index) {
    return IncomeType.values.firstWhere(
          (type) => type.typeIndex == index,
      orElse: () => IncomeType.month,
    );
  }

  static const int totalTypes = 2;
}
