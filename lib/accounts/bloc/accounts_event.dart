part of 'accounts_bloc.dart';

abstract class AccountsEvent extends Equatable {
  const AccountsEvent();

  @override
  List<Object> get props => [];
}

class AccountsStringQueryEvent extends AccountsEvent {
  const AccountsStringQueryEvent(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

class AccountsLocationQueryEvent extends AccountsEvent {
  const AccountsLocationQueryEvent(this.location);

  final Location location;

  @override
  List<Object> get props => [location];
}

class AccountsLoadedEvent extends AccountsEvent {
  const AccountsLoadedEvent(this.accounts);

  final List<Account> accounts;

  @override
  List<Object> get props => [accounts];
}