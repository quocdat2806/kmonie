import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_budget_event.freezed.dart';

@freezed
abstract class AddBudgetEvent with _$AddBudgetEvent {
  const factory AddBudgetEvent.init() = AddBudgetEventInit;
  const factory AddBudgetEvent.setBudget({required String itemTitle, required int amount}) = AddBudgetEventSetBudget;
  const factory AddBudgetEvent.resetInput() = AddBudgetEventResetInput;
  const factory AddBudgetEvent.inputKey({required String key}) = AddBudgetEventInputKey;
}
