class MonthlyArgs {
  final int year;
  final int month;
  final double income;
  final double expense;

  const MonthlyArgs({
    required this.year,
    required this.month,
    this.income = 0,
    this.expense = 0,
  });
}
