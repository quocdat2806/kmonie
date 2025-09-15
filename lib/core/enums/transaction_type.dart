enum TransactionType {
  expense(0, 'Chi tiêu'),
  income(1, 'Thu nhập'),
  transfer(2, 'Chuyển khoản');

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
