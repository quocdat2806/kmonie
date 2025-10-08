class DailyTransactionTotal {
  final double income;
  final double expense;
  final double transfer;

  const DailyTransactionTotal({
    this.income = 0,
    this.expense = 0,
    this.transfer = 0,
  });

  DailyTransactionTotal copyWith({
    double? income,
    double? expense,
    double? transfer,
  }) {
    return DailyTransactionTotal(
      income: income ?? this.income,
      expense: expense ?? this.expense,
      transfer: transfer ?? this.transfer,
    );
  }
}
