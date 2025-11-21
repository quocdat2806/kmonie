class TransactionAutomationGroup {
  int firstId;
  final int amount;
  final int transactionCategoryId;
  final String content;
  final int transactionType;
  final int hour;
  final int minute;
  final Set<int> days;
  final bool isActive;
  DateTime createdAt;
  DateTime? lastExecutedDate;

  TransactionAutomationGroup({
    required this.firstId,
    required this.amount,
    required this.transactionCategoryId,
    required this.content,
    required this.transactionType,
    required this.hour,
    required this.minute,
    required this.days,
    required this.isActive,
    required this.createdAt,
    this.lastExecutedDate,
  });
}
