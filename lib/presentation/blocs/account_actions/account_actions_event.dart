import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';

part 'account_actions_event.freezed.dart';

@freezed
abstract class AccountActionsEvent with _$AccountActionsEvent {
  const factory AccountActionsEvent.loadAccounts() = LoadAccounts;
  const factory AccountActionsEvent.createAccount(Account account) = CreateAccount;
  const factory AccountActionsEvent.updateAccount(Account account) = UpdateAccount;
  const factory AccountActionsEvent.deleteAccount(int accountId) = DeleteAccount;
  const factory AccountActionsEvent.pinAccount(int accountId) = PinAccount;
  const factory AccountActionsEvent.unpinAccount(int accountId) = UnpinAccount;
  const factory AccountActionsEvent.updateAccountBalance(int accountId, int newBalance) = UpdateAccountBalance;
  const factory AccountActionsEvent.accountsStreamUpdated(List<Account> accounts) = AccountsStreamUpdated;
}
