import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/entities/entities.dart';

import 'account_actions_event.dart';
import 'account_actions_state.dart';

class AccountActionsBloc extends Bloc<AccountActionsEvent, AccountActionsState> {
  AccountActionsBloc(this._accountRepository) : super(const AccountActionsState.initial()) {
    on<LoadAccounts>(_onLoadAccounts);
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
  }

  final AccountRepository _accountRepository;
  StreamSubscription<List<Account>>? _accountsSub;

  Future<void> _onLoadAccounts(LoadAccounts event, Emitter<AccountActionsState> emit) async {
    emit(const AccountActionsState.loading());
    final result = await _accountRepository.getAllAccounts();
    result.fold((f) => emit(AccountActionsState.error(f.message)), (accounts) => emit(AccountActionsState.loaded(accounts)));
  }

  Future<void> _onCreateAccount(CreateAccount event, Emitter<AccountActionsState> emit) async {
    emit(const AccountActionsState.loading());
    final result = await _accountRepository.createAccount(event.account);
    result.fold((f) => emit(AccountActionsState.error(f.message)), (_) => add(const LoadAccounts()));
  }

  Future<void> _onUpdateAccount(UpdateAccount event, Emitter<AccountActionsState> emit) async {
    emit(const AccountActionsState.loading());
    final result = await _accountRepository.updateAccount(event.account);
    result.fold((f) => emit(AccountActionsState.error(f.message)), (_) => add(const LoadAccounts()));
  }

  Future<void> _onDeleteAccount(DeleteAccount event, Emitter<AccountActionsState> emit) async {
    emit(const AccountActionsState.loading());
    final result = await _accountRepository.deleteAccount(event.accountId);
    result.fold((f) => emit(AccountActionsState.error(f.message)), (_) => add(const LoadAccounts()));
  }

  Future<void> _onPinAccount(PinAccount event, Emitter<AccountActionsState> emit) async {
    emit(const AccountActionsState.loading());
    final result = await _accountRepository.pinAccount(event.accountId);
    result.fold((f) => emit(AccountActionsState.error(f.message)), (_) => add(const LoadAccounts()));
  }

  Future<void> _onUnpinAccount(UnpinAccount event, Emitter<AccountActionsState> emit) async {
    emit(const AccountActionsState.loading());
    final result = await _accountRepository.unpinAccount(event.accountId);
    result.fold((f) => emit(AccountActionsState.error(f.message)), (_) => add(const LoadAccounts()));
  }

  Future<void> _onUpdateAccountBalance(UpdateAccountBalance event, Emitter<AccountActionsState> emit) async {
    final result = await _accountRepository.updateAccountBalance(event.accountId, event.newBalance);
    result.fold((f) => emit(AccountActionsState.error(f.message)), (_) => add(const LoadAccounts()));
  }

  void _onAccountsStreamUpdated(AccountsStreamUpdated event, Emitter<AccountActionsState> emit) {
    emit(AccountActionsState.loaded(event.accounts));
  }

  @override
  Future<void> close() async {
    await _accountsSub?.cancel();
    return super.close();
  }
}
