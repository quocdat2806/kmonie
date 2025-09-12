import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kmonie/core/constants/navigation_constants.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainState()) {
    on<MainSwitchTab>((MainSwitchTab event, Emitter<MainState> emit) {
      if (event.index < 0 || event.index >= NavigationConstants.totalPages) {
        return;
      }

      if (event.index == state.selectedIndex) return;

      emit(state.copyWith(selectedIndex: event.index));
    });
  }
}
