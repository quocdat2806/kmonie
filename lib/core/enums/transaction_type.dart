import 'package:kmonie/core/constants/constants.dart';

enum TransactionType {
  expense(0, AppTextConstants.expense),
  income(1, AppTextConstants.income);

  const TransactionType(this.typeIndex, this.displayName);

  final int typeIndex;
  final String displayName;

  static TransactionType fromIndex(int index) {
    return TransactionType.values.firstWhere(
      (type) => type.typeIndex == index,
      orElse: () => TransactionType.expense,
    );
  }

  static const int totalTypes = 2;
}

extension ExTransactionType on TransactionType {
  static const List<TransactionType> transactionTypes = TransactionType.values;
  static List<String> transactionTypeNames = transactionTypes
      .map((e) => e.displayName)
      .toList();
}
