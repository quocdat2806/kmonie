import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/entities/entities.dart';

part 'account_event.freezed.dart';

@freezed
abstract class AccountEvent with _$AccountEvent {
  const factory AccountEvent.loadAccounts() = LoadAccounts;
  const factory AccountEvent.createAccount(Account account) = CreateAccount;
  const factory AccountEvent.updateAccount(Account account) = UpdateAccount;
  const factory AccountEvent.deleteAccount(int accountId) = DeleteAccount;
  const factory AccountEvent.pinAccount(int accountId) = PinAccount;
  const factory AccountEvent.unpinAccount(int accountId) = UnpinAccount;
  const factory AccountEvent.updateAccountBalance(int accountId, int newBalance) = UpdateAccountBalance;
  const factory AccountEvent.accountsStreamUpdated(List<Account> accounts) = AccountsStreamUpdated;
}
