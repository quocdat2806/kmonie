import '../constant/exports.dart';

enum IncomeType {
  month(0, TextConstants.monthIncomeTitle),
  year(1, TextConstants.yearIncomeTitle);

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
extension ExIncomeType on IncomeType{
static List<String> toList = IncomeType.values
    .map((e) => e.displayName)
    .toList();
}
