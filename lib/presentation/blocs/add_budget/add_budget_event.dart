import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/args/args.dart';
part 'add_budget_event.freezed.dart';

@freezed
abstract class AddBudgetEvent with _$AddBudgetEvent {
  const factory AddBudgetEvent.init({required AddBudgetArgs args}) =
      AddBudgetEventInit;
  const factory AddBudgetEvent.inputKey({required String key}) =
      AddBudgetEventInputKey;
  const factory AddBudgetEvent.save() = AddBudgetEventSave;
  const factory AddBudgetEvent.setCurrentInputIdCategory({int? id}) =
      AddBudgetEventSetCurrentInputIdCategory;
}
