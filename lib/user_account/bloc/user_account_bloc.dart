import 'dart:async';
import 'package:accounts_repository/accounts_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'user_account_event.dart';

part 'user_account_state.dart';

class UserAccountBloc extends Bloc<UserAccountEvent, UserAccountState> {
  final AccountsRepository _accountsRepository;
  final User _user;

  UserAccountBloc({
    @required AccountsRepository accountsRepository,
    @required User user,
  })  : assert(accountsRepository != null),
        assert(user != null),
        _accountsRepository = accountsRepository,
        _user = user,
        super(const UserAccountState.unknown());

  @override
  Stream<UserAccountState> mapEventToState(UserAccountEvent event) async* {
    if (event is FetchUserAccountEvent) {
      yield* _mapFetchAccountEventToState(event);
    }

    if (event is CreateUserAccountEvent) {
      yield* _mapCreateAccountEventToState(event);
    }

    if (event is UpdateUserAccountStatusEvent) {
      yield* _mapUpdateUserAccountStatusEventToState(event);
    }
  }

  Stream<UserAccountState> _mapFetchAccountEventToState(
    FetchUserAccountEvent event,
  ) async* {
    yield UserAccountState.loading();

    var account = await _accountsRepository.findByUserId(_user.id);

    if (account == Account.empty) {
      add(CreateUserAccountEvent());
    } else {
      yield UserAccountState.loaded(account);
    }
  }

  Stream<UserAccountState> _mapCreateAccountEventToState(
    CreateUserAccountEvent event,
  ) async* {
    yield UserAccountState.loading();

    var account = Account.empty.copyWith(
      userId: _user.id,
      phoneNumber: _user.phoneNumber,
    );

    await _accountsRepository.add(account);

    add(FetchUserAccountEvent());
  }

  Stream<UserAccountState> _mapUpdateUserAccountStatusEventToState(
    UpdateUserAccountStatusEvent event,
  ) async* {
    var account = state.account.copyWith(status: event.status);

    yield UserAccountState.loading();

    await _accountsRepository.update(account);

    yield UserAccountState.loaded(account);
  }

  void toggleUserStatus() {
    switch (state.account.status) {
      case AccountStatus.closed:
        updateUserStatus(AccountStatus.open);
        break;
      case AccountStatus.open:
        updateUserStatus(AccountStatus.closed);
        break;
    }
  }

  void updateUserStatus(AccountStatus status) {
    add(UpdateUserAccountStatusEvent(status));
  }
}
