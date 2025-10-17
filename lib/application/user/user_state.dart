import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';
part 'user_state.freezed.dart';

@freezed
abstract class UserState with _$UserState {
  const factory UserState({User? user}) = _UserState;
}
