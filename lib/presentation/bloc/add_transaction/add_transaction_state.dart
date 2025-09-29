import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/enum/exports.dart';
import '../../../entity/exports.dart';
part 'add_transaction_state.freezed.dart';

@freezed
abstract class AddTransactionState with _$AddTransactionState {
  const AddTransactionState._();
  const factory AddTransactionState({
    @Default(0) int selectedIndex,
    @Default(<TransactionType, List<TransactionCategory>>{})
    Map<TransactionType, List<TransactionCategory>> categoriesByType,
    @Default(<TransactionType, int?>{})
    Map<TransactionType, int?> selectedCategoryIdByType,
    @Default(false) bool isKeyboardVisible,
    @Default('') String note,
    @Default(0) int amount,
    @Default(LoadStatus.initial) LoadStatus loadStatus,
    DateTime? date,
  }) = _AddTransactionState;

  TransactionType get currentType => TransactionType.fromIndex(selectedIndex);
  List<TransactionCategory> categoriesFor(TransactionType t) =>
      categoriesByType[t] ?? const [];

  int? selectedCategoryIdFor(TransactionType t) => selectedCategoryIdByType[t];
}
