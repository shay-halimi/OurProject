part of 'account_bloc.dart';

enum AccountStateStatus { loading, loaded, empty, created, unknown }

class AccountState extends Equatable {
  const AccountState._({
    this.status = AccountStateStatus.unknown,
    this.account = Account.empty,
  });

  const AccountState.loading() : this._(status: AccountStateStatus.loading);

  const AccountState.loaded(Account account)
      : this._(status: AccountStateStatus.loaded, account: account);

  const AccountState.empty()
      : this._(status: AccountStateStatus.empty);

  const AccountState.created() : this._(status: AccountStateStatus.created);

  const AccountState.unknown() : this._();

  final AccountStateStatus status;
  final Account account;

  @override
  List<Object> get props => [status, account];
}
