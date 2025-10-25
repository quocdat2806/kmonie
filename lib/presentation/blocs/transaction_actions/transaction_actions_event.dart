import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kmonie/core/enums/enums.dart';

part 'transaction_actions_event.freezed.dart';

@freezed
class TransactionActionsEvent with _$TransactionActionsEvent {
  const factory TransactionActionsEvent.switchTab(int index) = SwitchTab;

  const factory TransactionActionsEvent.loadCategories(TransactionType type) = LoadCategories;

  const factory TransactionActionsEvent.categoryChanged({required TransactionType type, required int categoryId}) = CategoryChanged;

  const factory TransactionActionsEvent.toggleKeyboardVisibility() = ToggleKeyboardVisibility;
  const factory TransactionActionsEvent.amountChanged(String value) = AmountChanged;
  const factory TransactionActionsEvent.noteChanged(String value) = NoteChanged;
  const factory TransactionActionsEvent.saveTransaction() = SaveTransaction;
  const factory TransactionActionsEvent.submitTransaction() = SubmitTransaction;
  const factory TransactionActionsEvent.selectDateChange(DateTime date) = SelectDateChange;
  const factory TransactionActionsEvent.requestSelectDate() = RequestSelectDate;
  const factory TransactionActionsEvent.checkOverBudget() = CheckOverBudget;
  const factory TransactionActionsEvent.clearSelectDateState() = ClearSelectDateState;
  const factory TransactionActionsEvent.clearOverBudgetState() = ClearOverBudgetState;
  const factory TransactionActionsEvent.initialize() = Initialize;
  const factory TransactionActionsEvent.setShouldScroll(bool shouldScroll) = SetShouldScroll;
  const factory TransactionActionsEvent.setHasScrolledOnce(bool hasScrolledOnce) = SetHasScrolledOnce;
  const factory TransactionActionsEvent.resetScrollState() = ResetScrollState;
  const factory TransactionActionsEvent.updateKeyboardHeight(double height) = UpdateKeyboardHeight;
}
