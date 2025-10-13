import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_event.freezed.dart';

@freezed
abstract class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.checkAuthStatus() = CheckAuthStatus;
  const factory AuthenticationEvent.setAuthenticated() = SetAuthenticated;
  const factory AuthenticationEvent.logout() = Logout;
}
