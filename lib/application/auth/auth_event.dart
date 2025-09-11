abstract class AuthEvent {}

class AuthAppStarted extends AuthEvent {}
class AuthSignedIn extends AuthEvent {
  AuthSignedIn(this.token);
  final String token;
}
class AuthSignedOut extends AuthEvent {}
