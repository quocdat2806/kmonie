import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';

part 'account_actions_state.freezed.dart';

@freezed
abstract class AccountActionsState with _$AccountActionsState {
  const factory AccountActionsState({@Default([]) List<Account> accounts}) =
      _AccountActionsState;
}
