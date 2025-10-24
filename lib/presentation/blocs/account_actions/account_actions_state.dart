import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';

part 'account_actions_state.freezed.dart';

@freezed
abstract class AccountActionsState with _$AccountActionsState {
  const factory AccountActionsState.initial() = _Initial;
  const factory AccountActionsState.loading() = _Loading;
  const factory AccountActionsState.loaded(List<Account> accounts) = _Loaded;
  const factory AccountActionsState.error(String message) = _Error;
}
