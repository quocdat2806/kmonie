part of 'add_transaction_bloc.dart';

class AddTransactionState extends Equatable {
  const AddTransactionState({
    this.selectedIndex = 0,
    this.selectedCategoriesByType = const <TransactionType, String?>{},
    this.message,
  });

  final int selectedIndex;
  final Map<TransactionType, String?> selectedCategoriesByType;
  final String? message; // used when error

  AddTransactionState copyWith({
    int? selectedIndex,
    Map<TransactionType, String?>? selectedCategoriesByType,
    String? message,
  }) {
    return AddTransactionState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedCategoriesByType:
          selectedCategoriesByType ?? this.selectedCategoriesByType,
      message: message ?? this.message,
    );
  }

  TransactionType get currentTransactionType =>
      TransactionType.fromIndex(selectedIndex);

  String? selectedCategoryForType(TransactionType type) =>
      selectedCategoriesByType[type];

  @override
  List<Object?> get props => <Object?>[
    selectedIndex,
    selectedCategoriesByType,
    message,
  ];
}
