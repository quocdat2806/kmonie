import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/exports.dart';
import 'add_transaction_event.dart';
import 'add_transaction_state.dart';

class AddTransactionBloc
    extends Bloc<AddTransactionEvent, AddTransactionState> {
  AddTransactionBloc() : super(const AddTransactionState()) {
    on<AddTransactionSwitchTab>(
      (event, emit) => _onSwitchTab(event.index, emit),
    );

    on<AddTransactionCategoryChanged>(
      (event, emit) => _onCategoryChanged(event.type, event.categoryId, emit),
    );
  }

  void _onSwitchTab(int index, Emitter<AddTransactionState> emit) {
    if (!TransactionType.values.any((type) => type.typeIndex == index)) return;

    if (index == state.selectedIndex) return;

    emit(
      state.copyWith(
        selectedIndex: index,
        selectedCategoriesByType: const <TransactionType, String?>{},
      ),
    );
  }

  void _onCategoryChanged(
    TransactionType type,
    String categoryId,
    Emitter<AddTransactionState> emit,
  ) {
    final updated = <TransactionType, String?>{type: categoryId};
    if(!state.isKeyboardVisible){
      emit(state.copyWith(isKeyboardVisible: !state.isKeyboardVisible));
    }
    emit(state.copyWith(selectedCategoriesByType: updated));
  }
}
