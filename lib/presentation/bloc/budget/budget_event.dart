import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_event.freezed.dart';

@freezed
abstract class BudgetEvent with _$BudgetEvent {
  const factory BudgetEvent.init({required DateTime period}) = BudgetEventInit;
  const factory BudgetEvent.changePeriod({required DateTime period}) = BudgetEventChangePeriod;
  const factory BudgetEvent.setBudget({required DateTime period, required int categoryId, required int amount}) = BudgetEventSetBudget;
}
