import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/application/user/user.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/services/services.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this.secure, this.userBloc, this.userService) : super(const AuthenticationState()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SetAuthenticated>(_onSetAuthenticated);
    on<Logout>(_onLogout);
  }

  final SecureStorageService secure;
  final UserBloc userBloc;
  final UserService userService;
  static const String tokenKey = AppConfigs.tokenKey;

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthenticationState> emit) async {
    try {
      final String? token = await secure.read(tokenKey);
      final User? user = await userService.getUser();

      if (token != null && token.isNotEmpty && user != null) {
        userBloc.add(UserEvent.setUser(user));
        emit(const AuthenticationState(isAuthenticated: true));
        return;
      }
    } catch (_) {
      logger.e('Error checking auth status');
    }
  }

  Future<void> _onSetAuthenticated(SetAuthenticated event, Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationState(isAuthenticated: true));
  }

  Future<void> _onLogout(Logout event, Emitter<AuthenticationState> emit) async {
    try {
      await secure.delete(tokenKey);
      await userService.clearUser();
      userBloc.add(const UserEvent.setUser(null));
      emit(const AuthenticationState());
      logger.i('User logged out successfully');
    } catch (e) {
      logger.e('Error during logout: $e');
      emit(const AuthenticationState());
    }
  }
}
