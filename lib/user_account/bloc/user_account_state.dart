part of 'user_account_bloc.dart';

enum AccountStateStatus { loading, loaded, unknown }

class UserAccountState extends Equatable {
  const UserAccountState._({
    this.status = AccountStateStatus.unknown,
    this.account = Account.empty,
  });

  const UserAccountState.loading() : this._(status: AccountStateStatus.loading);

  const UserAccountState.loaded(Account account)
      : this._(status: AccountStateStatus.loaded, account: account);

  const UserAccountState.unknown() : this._();

  final AccountStateStatus status;
  final Account account;

  @override
  List<Object> get props => [status, account];
}
