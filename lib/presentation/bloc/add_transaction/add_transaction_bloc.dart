import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/core/enums/transaction_type.dart';

part 'add_transaction_event.dart';
part 'add_transaction_state.dart';
part 'add_transaction_bloc.freezed.dart';

class AddTransactionBloc
    extends Bloc<AddTransactionEvent, AddTransactionState> {
  AddTransactionBloc() : super(const AddTransactionState.initial()) {
    on<AddTransactionEvent>((event, emit) {
      event.when(switchTab: (index) => _onSwitchTab(index, emit));
    });
  }

  void _onSwitchTab(int index, Emitter<AddTransactionState> emit) {
    if (!TransactionType.values.any((type) => type.typeIndex == index)) {
      return;
    }

    if (index == state.selectedIndex) return;

    emit(AddTransactionState.loaded(selectedIndex: index));
  }
}
