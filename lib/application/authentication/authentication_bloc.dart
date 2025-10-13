import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/entity/user/user.dart';
import 'package:kmonie/application/user/user.dart';
import 'package:kmonie/core/di/injection_container.dart';
import 'package:kmonie/core/utils/logger.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this.secure, this.userBloc) : super(const AuthenticationState()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SetAuthenticated>(_onSetAuthenticated);
    on<Logout>(_onLogout);
  }

  final SecureStorageService secure;
  final UserBloc userBloc;
  static const String tokenKey = AppConfigs.tokenKey;
  static const String userKey = AppConfigs.userKey;

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthenticationState> emit) async {
    try {
      final String? token = await secure.read(tokenKey);
      final String? userJson = await secure.read(userKey);

      if (token != null && token.isNotEmpty && userJson != null) {
        final Map<String, dynamic> userMap = json.decode(userJson) as Map<String, dynamic>;
        final User user = User.fromJson(userMap);

        sl<UserBloc>().add(UserEvent.setUser(user));

        emit(const AuthenticationState(isAuthenticated: true));
        return;
      }

      // Emit unauthenticated state nếu không có token hoặc user data
      emit(const AuthenticationState());
    } catch (_) {
      logger.e('Error checking auth status');
      // Emit unauthenticated state khi có lỗi
      emit(const AuthenticationState());
    }
  }

  Future<void> _onSetAuthenticated(SetAuthenticated event, Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationState(isAuthenticated: true));
  }

  Future<void> _onLogout(Logout event, Emitter<AuthenticationState> emit) async {
    try {
      // Xóa token và user data từ secure storage
      await secure.delete(tokenKey);
      await secure.delete(userKey);

      // Clear user từ UserBloc
      sl<UserBloc>().add(const UserEvent.clearUser());

      // Emit unauthenticated state
      emit(const AuthenticationState());

      logger.i('User logged out successfully');
    } catch (e) {
      logger.e('Error during logout: $e');
      // Vẫn emit unauthenticated state ngay cả khi có lỗi
      emit(const AuthenticationState());
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await secure.read(tokenKey);
    return token != null && token.isNotEmpty;
  }
}
