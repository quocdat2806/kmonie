import 'package:bloc/bloc.dart';
import 'package:kmonie/core/enums/main_tabs.dart';

import 'main_event.dart';
import 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainState()) {
    on<MainSwitchTab>((event, emit) {
      if (event.index < 0 || event.index >= MainTabs.totalTypes) return;

      if (event.index == state.selectedIndex) return;

      emit(state.copyWith(selectedIndex: event.index));
    });
  }
}