import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';

part 'user_event.freezed.dart';

@freezed
abstract class UserEvent with _$UserEvent {
  const factory UserEvent.setUser(User? user) = SetUser;
}
