import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/core/enums/enums.dart';
part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isPasswordObscured,
    @Default('') String username,
    @Default('') String password,
    @Default(LoadStatus.initial) LoadStatus loadStatus,
  }) = _AuthState;
}
