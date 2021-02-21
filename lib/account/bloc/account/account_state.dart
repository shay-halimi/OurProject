part of 'account_bloc.dart';

enum AccountStatus { loading, loaded, unknown }

class AccountState extends Equatable {
  const AccountState._({
    this.status = AccountStatus.unknown,
  });

  const AccountState.unknown() : this._();

  final AccountStatus status;

  @override
  List<Object> get props => [status];
}
