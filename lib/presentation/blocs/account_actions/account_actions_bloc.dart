import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/repositories/repositories.dart';

import 'account_actions_event.dart';
import 'account_actions_state.dart';

class AccountActionsBloc extends Bloc<AccountActionsEvent, AccountActionsState> {
  AccountActionsBloc(this._accountRepository) : super(const AccountActionsState()) {
    on<LoadAllAccounts>(_onLoadAccounts);
    on<CreateAccount>(_onCreateAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<PinAccount>(_onPinAccount);
    on<UnpinAccount>(_onUnpinAccount);
    on<UpdateAccountBalance>(_onUpdateAccountBalance);
    on<AccountsStreamUpdated>(_onAccountsStreamUpdated);

    _accountsSub = _accountRepository.watchAccounts().listen((accounts) {
      add(AccountActionsEvent.accountsStreamUpdated(accounts));
    });

    add(const LoadAllAccounts());
  }

  final AccountRepository _accountRepository;
  StreamSubscription<List<Account>>? _accountsSub;

  Future<void> _onLoadAccounts(LoadAllAccounts event, Emitter<AccountActionsState> emit) async {
    final result = await _accountRepository.getAllAccounts();
    result.fold((f) => emit(const AccountActionsState()), (accounts) => emit(AccountActionsState(accounts: accounts)));
  }

  Future<void> _onCreateAccount(CreateAccount event, Emitter<AccountActionsState> emit) async {
    final result = await _accountRepository.createAccount(event.account);
    result.fold((f) {
      logger.e('Error creating account: ${f.message}');
    }, (_) => add(const LoadAllAccounts()));
  }

  Future<void> _onUpdateAccount(UpdateAccount event, Emitter<AccountActionsState> emit) async {
    final result = await _accountRepository.updateAccount(event.account);
    result.fold((f) {
      logger.e('Error update account: ${f.message}');
    }, (_) => add(const LoadAllAccounts()));
  }

  Future<void> _onDeleteAccount(DeleteAccount event, Emitter<AccountActionsState> emit) async {
    final result = await _accountRepository.deleteAccount(event.accountId);
    result.fold((f) {
      logger.e('Error delete account: ${f.message}');
    }, (_) => add(const LoadAllAccounts()));
  }

  Future<void> _onPinAccount(PinAccount event, Emitter<AccountActionsState> emit) async {
    final updatedAccounts = state.accounts.map((Account acc) {
      if (acc.id != null && acc.id != event.accountId && acc.isPinned) {
        return Account(id: acc.id, name: acc.name, type: acc.type, amount: acc.amount, balance: acc.balance, accountNumber: acc.accountNumber, bankId: acc.bankId);
      }
      if (acc.id == event.accountId) {
        return Account(id: acc.id, name: acc.name, type: acc.type, amount: acc.amount, balance: acc.balance, accountNumber: acc.accountNumber, bankId: acc.bankId, isPinned: true);
      }
      return acc;
    }).toList();
    emit(AccountActionsState(accounts: updatedAccounts));

    final result = await _accountRepository.pinAccount(event.accountId);
    result.fold((f) {
      add(const LoadAllAccounts());
    }, (_) {});
  }

  Future<void> _onUnpinAccount(UnpinAccount event, Emitter<AccountActionsState> emit) async {
    final updatedAccounts = state.accounts.map((Account acc) {
      if (acc.id == event.accountId) {
        return Account(id: acc.id, name: acc.name, type: acc.type, amount: acc.amount, balance: acc.balance, accountNumber: acc.accountNumber, bankId: acc.bankId);
      }
      return acc;
    }).toList();
    emit(AccountActionsState(accounts: updatedAccounts));

    final result = await _accountRepository.unpinAccount(event.accountId);
    result.fold((f) {
      add(const LoadAllAccounts());
    }, (_) {});
  }

  Future<void> _onUpdateAccountBalance(UpdateAccountBalance event, Emitter<AccountActionsState> emit) async {
    final result = await _accountRepository.updateAccountBalance(event.accountId, event.newBalance);
    result.fold((f) {
      logger.e('Error when update balance account: ${f.message}');
    }, (_) => add(const LoadAllAccounts()));
  }

  void _onAccountsStreamUpdated(AccountsStreamUpdated event, Emitter<AccountActionsState> emit) {
    emit(AccountActionsState(accounts: event.accounts));
  }

  @override
  Future<void> close() async {
    await _accountsSub?.cancel();
    return super.close();
  }
}
