part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class LoadAccount extends AccountEvent {}

class AddAccount extends AccountEvent {
  final Account account;

  const AddAccount(this.account);

  @override
  List<Object> get props => [account];

  @override
  String toString() => 'AddAccount { account: $account }';
}

class UpdateAccount extends AccountEvent {
  final Account updatedAccount;

  const UpdateAccount(this.updatedAccount);

  @override
  List<Object> get props => [updatedAccount];

  @override
  String toString() => 'UpdateAccount { updatedAccount: $updatedAccount }';
}

class AccountUpdated extends AccountEvent {
  final List<Account> accounts;

  const AccountUpdated(this.accounts);

  @override
  List<Object> get props => [accounts];
}