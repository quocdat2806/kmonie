import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/exports.dart';
part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(String token) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  AuthStatus get status => when(
    loading: () => AuthStatus.loading,
    authenticated: (_) => AuthStatus.authenticated,
    unauthenticated: () => AuthStatus.unauthenticated,
  );
}
