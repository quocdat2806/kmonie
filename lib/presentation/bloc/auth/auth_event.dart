import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.togglePasswordVisibility() = TogglePasswordVisibility;
  const factory AuthEvent.userNameChanged(String username) = UserNameChanged;
  const factory AuthEvent.passwordChanged(String password) = PasswordChanged;
  const factory AuthEvent.handleSubmit() = HandleSubmit;
}
