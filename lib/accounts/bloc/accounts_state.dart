part of 'accounts_bloc.dart';

enum AccountsStateStatus { loading, loaded, unknown }

class AccountsState extends Equatable {
  const AccountsState._({
    this.status = AccountsStateStatus.unknown,
    this.accounts = const [],
  });

  const AccountsState.loading() : this._(status: AccountsStateStatus.loading);

  const AccountsState.loaded(List<Account> accounts)
      : this._(status: AccountsStateStatus.loaded, accounts: accounts);

  const AccountsState.unknown() : this._();

  final AccountsStateStatus status;
  final List<Account> accounts;

  @override
  List<Object> get props => [status, accounts];
}
