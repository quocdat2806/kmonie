part of 'add_transaction_bloc.dart';

abstract class AddTransactionEvent extends Equatable {
  const AddTransactionEvent();
}

class AddTransactionSwitchTab extends AddTransactionEvent {
  const AddTransactionSwitchTab(this.index);
  final int index;

  @override
  List<Object?> get props => <Object?>[index];
}

class AddTransactionCategoryChanged extends AddTransactionEvent {
  const AddTransactionCategoryChanged({
    required this.type,
    required this.categoryId,
  });

  final TransactionType type;
  final String categoryId;

  @override
  List<Object?> get props => <Object?>[type, categoryId];
}
