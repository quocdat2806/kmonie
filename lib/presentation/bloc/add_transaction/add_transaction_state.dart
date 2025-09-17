import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/core/enums/transaction_type.dart';

part 'add_transaction_state.freezed.dart';

@freezed
class AddTransactionState with _$AddTransactionState {
  const AddTransactionState._();

  const factory AddTransactionState({
    @Default(0) int selectedIndex,
    @Default(<TransactionType, String?>{}) Map<TransactionType, String?> selectedCategoriesByType,
    String? message,
  }) = _AddTransactionState;

  TransactionType get currentTransactionType =>
      TransactionType.fromIndex(selectedIndex);

  String? selectedCategoryForType(TransactionType type) =>
      selectedCategoriesByType[type];
}
