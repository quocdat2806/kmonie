import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/enum/exports.dart';
part 'add_transaction_event.freezed.dart';

@freezed
class AddTransactionEvent with _$AddTransactionEvent {
  const factory AddTransactionEvent.switchTab(int index) =
      AddTransactionSwitchTab;

  const factory AddTransactionEvent.categoryChanged({
    required TransactionType type,
    required String categoryId,
  }) = AddTransactionCategoryChanged;
  const factory AddTransactionEvent.toggleKeyboardVisibility() =
      AddTransactionToggleKeyboardVisibility;
}
