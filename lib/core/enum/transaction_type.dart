import '../constant/exports.dart';

enum TransactionType {
  expense(0, TextConstants.expenseTabText),
  income(1, TextConstants.incomeTabText),
  transfer(2, TextConstants.transferTabText);

  const TransactionType(this.typeIndex, this.displayName);

  final int typeIndex;
  final String displayName;

  static TransactionType fromIndex(int index) {
    return TransactionType.values.firstWhere(
      (type) => type.typeIndex == index,
      orElse: () => TransactionType.expense,
    );
  }

  static const int totalTypes = 3;
}

extension ExTransactionType on TransactionType {
  static const List<TransactionType> transactionTypes = TransactionType.values;
}
