import 'package:bloc/bloc.dart';
import 'main_event.dart';
import 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainState()) {
    on<MainSwitchTab>((event, emit) {
      if (event.index == state.selectedIndex) return;
      emit(state.copyWith(selectedIndex: event.index));
    });
  }
}
