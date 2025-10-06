import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/enum/export.dart';

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
  const factory TransactionActionsEvent.initialize() = Initialize;
}
