import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/entities/entities.dart';

import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this._userService) : super(const UserState.initial()) {
    on<LoadUser>(_onLoadUser);
    on<SetUser>(_onSetUser);
    on<UpdateUser>(_onUpdateUser);
    on<ClearUser>(_onClearUser);
  }

  final UserService _userService;

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(const UserState.loading());

    try {
      final user = await _userService.getUser();
      if (user != null) {
        emit(UserState.loaded(user));
      } else {
        emit(const UserState.initial());
      }
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  Future<void> _onSetUser(SetUser event, Emitter<UserState> emit) async {
    try {
      await _userService.saveUser(event.user);
      emit(UserState.loaded(event.user));
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      await _userService.updateUser(event.user);
      emit(UserState.loaded(event.user));
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  Future<void> _onClearUser(ClearUser event, Emitter<UserState> emit) async {
    try {
      await _userService.clearUser();
      emit(const UserState.initial());
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  User? get currentUser {
    return state.maybeWhen(loaded: (user) => user, orElse: () => null);
  }

  bool get isUserLoaded {
    return state.maybeWhen(loaded: (_) => true, orElse: () => false);
  }
}
