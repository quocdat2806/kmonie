import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/enum/export.dart';

part 'add_transaction_event.freezed.dart';

@freezed
class AddTransactionEvent with _$AddTransactionEvent {
  const factory AddTransactionEvent.switchTab(int index) = SwitchTab;

  const factory AddTransactionEvent.loadCategories(TransactionType type) =
      LoadCategories;

  const factory AddTransactionEvent.categoryChanged({
    required TransactionType type,
    required int categoryId,
  }) = CategoryChanged;

  const factory AddTransactionEvent.toggleKeyboardVisibility() =
      ToggleKeyboardVisibility;
  const factory AddTransactionEvent.amountChanged(String value) = AmountChanged;
  const factory AddTransactionEvent.noteChanged(String value) = NoteChanged;
  const factory AddTransactionEvent.saveTransaction() = SaveTransaction;
}
