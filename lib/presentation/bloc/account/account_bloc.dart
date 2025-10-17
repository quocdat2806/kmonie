import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/entities/entities.dart';

import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc(this._accountRepository) : super(const AccountState.initial()) {
    on<LoadAccounts>(_onLoadAccounts);
    on<CreateAccount>(_onCreateAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<PinAccount>(_onPinAccount);
    on<UnpinAccount>(_onUnpinAccount);
    on<UpdateAccountBalance>(_onUpdateAccountBalance);
    on<AccountsStreamUpdated>(_onAccountsStreamUpdated);

    _accountsSub = _accountRepository.watchAccounts().listen((accounts) {
      add(AccountEvent.accountsStreamUpdated(accounts));
    });
  }

  final AccountRepository _accountRepository;
  StreamSubscription<List<Account>>? _accountsSub;

  Future<void> _onLoadAccounts(LoadAccounts event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());

    final result = await _accountRepository.getAllAccounts();
    result.fold((failure) => emit(AccountState.error(failure.message)), (accounts) => emit(AccountState.loaded(accounts)));
  }

  Future<void> _onCreateAccount(CreateAccount event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());

    final result = await _accountRepository.createAccount(event.account);
    result.fold((failure) => emit(AccountState.error(failure.message)), (account) {
      add(const LoadAccounts());
    });
  }

  Future<void> _onUpdateAccount(UpdateAccount event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());

    final result = await _accountRepository.updateAccount(event.account);
    result.fold((failure) => emit(AccountState.error(failure.message)), (account) {
      add(const LoadAccounts());
    });
  }

  Future<void> _onDeleteAccount(DeleteAccount event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());

    final result = await _accountRepository.deleteAccount(event.accountId);
    result.fold((failure) => emit(AccountState.error(failure.message)), (_) {
      add(const LoadAccounts());
    });
  }

  Future<void> _onPinAccount(PinAccount event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());

    final result = await _accountRepository.pinAccount(event.accountId);
    result.fold((failure) => emit(AccountState.error(failure.message)), (_) {
      add(const LoadAccounts());
    });
  }

  Future<void> _onUnpinAccount(UnpinAccount event, Emitter<AccountState> emit) async {
    emit(const AccountState.loading());

    final result = await _accountRepository.unpinAccount(event.accountId);
    result.fold((failure) => emit(AccountState.error(failure.message)), (_) {
      add(const LoadAccounts());
    });
  }

  Future<void> _onUpdateAccountBalance(UpdateAccountBalance event, Emitter<AccountState> emit) async {
    final result = await _accountRepository.updateAccountBalance(event.accountId, event.newBalance);
    result.fold((failure) => emit(AccountState.error(failure.message)), (_) {
      add(const LoadAccounts());
    });
  }

  void _onAccountsStreamUpdated(AccountsStreamUpdated event, Emitter<AccountState> emit) {
    emit(AccountState.loaded(event.accounts));
  }

  @override
  Future<void> close() async {
    await _accountsSub?.cancel();
    return super.close();
  }
}
