import 'dart:async';

import 'package:accounts_repository/accounts_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc({
    @required AccountsRepository accountsRepository,
  })  : assert(accountsRepository != null),
        _accountsRepository = accountsRepository,
        super(const AccountsState.unknown()) {
    _accountsSubscription = _accountsRepository.accounts().listen((event) {
      add(AccountsLoadedEvent(event));
    });
  }

  final AccountsRepository _accountsRepository;
  StreamSubscription<List<Account>> _accountsSubscription;

  @override
  Future<void> close() {
    _accountsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<AccountsState> mapEventToState(
    AccountsEvent event,
  ) async* {
    if (event is AccountsStringQueryEvent) {
      /// todo
      yield const AccountsState.loading();
    } else if (event is AccountsLoadedEvent) {
      yield AccountsState.loaded(event.accounts);
    } else {
      yield const AccountsState.unknown();
    }
  }
}
