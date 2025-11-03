import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/services/transaction_category.dart';

part 'transaction_actions_state.freezed.dart';

enum SelectDateState { none, showDatePicker }

enum OverBudgetState { none, showOverBudgetDialog }

@freezed
abstract class TransactionActionsState with _$TransactionActionsState {
  const TransactionActionsState._();

  const factory TransactionActionsState({
    @Default(0) int selectedIndex,
    SeparatedCategories? separatedCategories,
    @Default(<TransactionType, int?>{})
    Map<TransactionType, int?> selectedCategoryIdByType,
    @Default(false) bool isKeyboardVisible,
    @Default('') String note,
    @Default(0) int amount,
    @Default(LoadStatus.initial) LoadStatus loadStatus,
    DateTime? date,
    @Default(SelectDateState.none) SelectDateState selectDateState,
    @Default(OverBudgetState.none) OverBudgetState overBudgetState,
    @Default(false) bool shouldScroll,
    @Default(false) bool hasScrolledOnce,
    @Default(0.0) double previousKeyboardHeight,
    @Default(false) bool hasPopped,
  }) = _TransactionActionsState;

  TransactionType get currentType => TransactionType.fromIndex(selectedIndex);

  List<TransactionCategory> categoriesFor(TransactionType t) {
    if (separatedCategories == null) return const [];

    switch (t) {
      case TransactionType.expense:
        return separatedCategories!.expense;
      case TransactionType.income:
        return separatedCategories!.income;
      case TransactionType.transfer:
        return separatedCategories!.transfer;
    }
  }

  int? selectedCategoryIdFor(TransactionType t) => selectedCategoryIdByType[t];
}
