import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/export.dart';
import '../../core/config/export.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.secure) : super(const AuthState.loading()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthSignedIn>(_onSignedIn);
    on<AuthSignedOut>(_onSignedOut);
  }

  final SecureStorageService secure;
  static const String tokenKey = AppConfigs.tokenKey;

  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final String? token = await secure.read(tokenKey);
      if (token != null && token.isNotEmpty) {
        emit(AuthState.authenticated(token));
        return;
      }
      emit(const AuthState.unauthenticated());
    } catch (_) {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSignedIn(AuthSignedIn event, Emitter<AuthState> emit) async {
    await secure.write(tokenKey, event.token);
    emit(AuthState.authenticated(event.token));
  }

  Future<void> _onSignedOut(
    AuthSignedOut event,
    Emitter<AuthState> emit,
  ) async {
    await secure.delete(tokenKey);
    emit(const AuthState.unauthenticated());
  }
}
