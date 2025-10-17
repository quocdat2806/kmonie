import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';

part 'account_state.freezed.dart';

@freezed
abstract class AccountState with _$AccountState {
  const factory AccountState.initial() = _Initial;
  const factory AccountState.loading() = _Loading;
  const factory AccountState.loaded(List<Account> accounts) = _Loaded;
  const factory AccountState.error(String message) = _Error;
}
