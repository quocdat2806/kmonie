import '../enum/exports.dart';

class IncomeConstants {
  IncomeConstants._();

  static const List<IncomeType> incomeTypes = IncomeType.values;
  static const int totalIncomeTypes = IncomeType.totalTypes;
  static const IncomeType defaultIncomeType = IncomeType.month;
}
