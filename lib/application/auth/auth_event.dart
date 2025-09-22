import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.appStarted() = AuthAppStarted;
  const factory AuthEvent.signedIn(String token) = AuthSignedIn;
  const factory AuthEvent.signedOut() = AuthSignedOut;
}
