import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entity/user/user.dart';

part 'user_event.freezed.dart';

@freezed
abstract class UserEvent with _$UserEvent {
  const factory UserEvent.loadUser() = LoadUser;
  const factory UserEvent.setUser(User user) = SetUser;
  const factory UserEvent.updateUser(User user) = UpdateUser;
  const factory UserEvent.clearUser() = ClearUser;
}
