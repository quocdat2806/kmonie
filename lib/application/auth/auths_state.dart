import 'package:equatable/equatable.dart';
import 'package:kmonie/core/enums/auth_status.dart';

abstract class AuthState extends Equatable {
  const AuthState(this.status);
  final AuthStatus status;
  @override
  List<Object?> get props => <Object?>[status];
}

class AuthLoading extends AuthState {
  const AuthLoading() : super(AuthStatus.loading);
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.token) : super(AuthStatus.authenticated);
  final String token;
  @override
  List<Object?> get props => <Object?>[status, token];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated() : super(AuthStatus.unauthenticated);
}
