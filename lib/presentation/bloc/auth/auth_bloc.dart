import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/presentation/bloc/auth/auth_event.dart';
import 'package:kmonie/presentation/bloc/auth/auth_state.dart';
import 'package:kmonie/repositories/auth.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/application/authentication/authentication_bloc.dart';
import 'package:kmonie/application/authentication/authentication_event.dart';
import 'package:kmonie/application/user/user.dart';
import 'package:kmonie/core/di/injection_container.dart';
import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/core/services/user.dart';
import 'package:kmonie/core/services/secure_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc(this._authRepository) : super(const AuthState()) {
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<UserNameChanged>(_onUpdateUsername);
    on<PasswordChanged>(_onUpdatePassword);
    on<HandleSubmit>(_onHandleSubmit);
  }

  void _onTogglePasswordVisibility(TogglePasswordVisibility event, Emitter<AuthState> emit) {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  void _onHandleSubmit(HandleSubmit event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));

    final result = await _authRepository.authenticate(username: state.username, password: state.password, mode: event.mode);

    result.fold((failure) => emit(state.copyWith(loadStatus: LoadStatus.error)), (response) async {
      emit(state.copyWith(loadStatus: LoadStatus.success));

      // Lưu token vào secure storage
      final secure = sl<SecureStorageService>();
      await secure.write(AppConfigs.tokenKey, response.data.token.accessToken);

      // Lưu user vào SharedPreferences qua UserService
      final userService = sl<UserService>();
      await userService.saveUser(response.data.user);

      // Set user vào UserBloc
      sl<UserBloc>().add(UserEvent.setUser(response.data.user));

      // Set authentication state
      sl<AuthenticationBloc>().add(const AuthenticationEvent.setAuthenticated());
    });
  }

  void _onUpdateUsername(UserNameChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onUpdatePassword(PasswordChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(password: event.password));
  }
}
