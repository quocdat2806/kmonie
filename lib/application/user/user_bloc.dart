import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this._userService) : super(const UserState()) {
    on<SetUser>(_onSetUser);
  }

  final UserService _userService;

  Future<void> _onSetUser(SetUser event, Emitter<UserState> emit) async {
    try {
      final u = event.user;
      if (u != null) {
        await _userService.saveUser(u);
      }
    } catch (e) {
      logger.e('Error setting user: $e');
    }
  }

  User? get currentUser => state.user;
}
