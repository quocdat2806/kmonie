import 'auth_event.dart';
import 'auths_state.dart';
import 'package:bloc/bloc.dart';
import 'package:kmonie/database/secure_storage_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.secure) : super(const AuthLoading()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthSignedIn>(_onSignedIn);
    on<AuthSignedOut>(_onSignedOut);
  }
  final SecureStorageService secure;
  static const String tokenKey = 'token';

  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final String? token = await secure.read(tokenKey);
      if (token != null && token.isNotEmpty) {
        emit(AuthAuthenticated(token));
        return;
      }
      emit(const AuthUnauthenticated());
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignedIn(AuthSignedIn event, Emitter<AuthState> emit) async {
    await secure.write(tokenKey, event.token);
    emit(AuthAuthenticated(event.token));
  }

  Future<void> _onSignedOut(
    AuthSignedOut event,
    Emitter<AuthState> emit,
  ) async {
    await secure.delete(tokenKey);
    emit(const AuthUnauthenticated());
  }
}
