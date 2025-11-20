import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/repositories/repositories.dart';

import 'add_budget_event.dart';
import 'add_budget_state.dart';

class AddBudgetBloc extends Bloc<AddBudgetEvent, AddBudgetState> {
  final BudgetRepository _budgetRepository;

  AddBudgetBloc(this._budgetRepository) : super(const AddBudgetState()) {
    on<AddBudgetEventInit>(_onInit);
    on<AddBudgetEventInputKey>(_onInputKey);
    on<AddBudgetEventSave>(_onSave);
    on<AddBudgetEventSetCurrentInputIdCategory>(_onSetCurrentInputIdCategory);
  }

  void _onInit(AddBudgetEventInit event, Emitter<AddBudgetState> emit) {
    final args = event.args;
    if (state.expenseCategories.isEmpty) {
      emit(
        state.copyWith(
          monthlyBudget: args.monthlyBudget ?? 0,
          categoryBudgets: args.categoryBudgets ?? {},
          expenseCategories: args.expenseCategories,
        ),
      );
    } else {
      final mergedCategoryBudgets = Map<int, int>.from(state.categoryBudgets);
      final argsCategoryBudgets = args.categoryBudgets ?? {};
      for (final entry in argsCategoryBudgets.entries) {
        if (!mergedCategoryBudgets.containsKey(entry.key)) {
          mergedCategoryBudgets[entry.key] = entry.value;
        }
      }
      final monthlyBudget = state.monthlyBudget > 0
          ? state.monthlyBudget
          : (args.monthlyBudget ?? 0);
      emit(
        state.copyWith(
          monthlyBudget: monthlyBudget,
          categoryBudgets: mergedCategoryBudgets,
        ),
      );
    }
  }

  void _onSetCurrentInputIdCategory(
    AddBudgetEventSetCurrentInputIdCategory event,
    Emitter<AddBudgetState> emit,
  ) {
    emit(
      state.copyWith(currentInputIdCategory: event.id, isKeyboardVisible: true),
    );
  }

  Future<void> _onSave(
    AddBudgetEventSave event,
    Emitter<AddBudgetState> emit,
  ) async {
    final amount = state.currentInput;
    if (amount <= 0) {
      emit(state.copyWith(isKeyboardVisible: false));
      return;
    }

    final now = DateTime.now();
    final year = now.year;
    final month = now.month;

    final categoryId = state.currentInputIdCategory;
    if (categoryId == null) {
      final result = await _budgetRepository.setMonthlyBudget(
        year: year,
        month: month,
        amount: amount,
      );
      result.fold(
        (failure) {
          logger.e('Error setting monthly budget: ${failure.message}');
          emit(state.copyWith(isKeyboardVisible: false));
        },
        (_) {
          emit(
            state.copyWith(
              monthlyBudget: amount,
              currentInput: 0,
              currentInputIdCategory: null,
              isKeyboardVisible: false,
            ),
          );
          AppStreamEvent.budgetChangedStatic();
        },
      );
    } else {
      final result = await _budgetRepository.setBudgetForCategory(
        year: year,
        month: month,
        categoryId: categoryId,
        amount: amount,
      );
      result.fold(
        (failure) {
          logger.e('Error setting category budget: ${failure.message}');
          emit(state.copyWith(isKeyboardVisible: false));
        },
        (_) {
          final updatedCategoryBudgets = Map<int, int>.from(
            state.categoryBudgets,
          );
          updatedCategoryBudgets[categoryId] = amount;
          emit(
            state.copyWith(
              categoryBudgets: updatedCategoryBudgets,
              currentInput: 0,
              currentInputIdCategory: null,
              isKeyboardVisible: false,
            ),
          );
          AppStreamEvent.budgetChangedStatic();
        },
      );
    }
  }

  void _onInputKey(AddBudgetEventInputKey event, Emitter<AddBudgetState> emit) {
    final key = event.key;
    if (key == 'SELECT_DATE' || key == '-' || key == '+' || key == ',') {
      return;
    }

    if (key == 'DONE') {
      add(const AddBudgetEvent.save());
      return;
    }
    if (key == 'CLEAR') {
      emit(state.copyWith(currentInput: state.currentInput ~/ 10));
      return;
    }
    final amountString = state.currentInput.toString();
    final newAmount = int.parse(amountString + key);
    emit(state.copyWith(currentInput: newAmount));
  }
}
