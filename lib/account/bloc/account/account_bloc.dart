import 'dart:async';
import 'package:accounts_repository/accounts_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'account_event.dart';

part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountsRepository _accountsRepository;

  AccountBloc({
    @required AccountsRepository accountsRepository,
  })  : assert(accountsRepository != null),
        _accountsRepository = accountsRepository,
        super(const AccountState.unknown());

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    // todo .
  }
}
