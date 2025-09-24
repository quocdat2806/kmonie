import 'package:kmonie/core/enum/income_type.dart' show IncomeType;

class IncomeConstants {
  IncomeConstants._();

  static const List<IncomeType> incomeTypes = IncomeType.values;
  static const int totalIncomeTypes = IncomeType.totalTypes;
  static const IncomeType defaultIncomeType = IncomeType.month;
}
