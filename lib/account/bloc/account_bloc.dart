import 'dart:async';

import 'package:accounts_repository/accounts_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'account_event.dart';

part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountsRepository _accountsRepository;
  final String _userId;
  StreamSubscription _accountSubscription;

  AccountBloc({
    @required AccountsRepository accountsRepository,
    @required String userId,
  })  : assert(accountsRepository != null),
        assert(userId != null),
        _accountsRepository = accountsRepository,
        _userId = userId,
        super(const AccountState.unknown());

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is LoadAccountEvent) {
      yield* _mapLoadAccountEventToState(event);
    }

    if (event is AccountUpdatedEvent) {
      yield* _mapAccountUpdatedEventToState(event);
    }

    if (event is UpdateAccountStatusEvent) {
      yield* _mapUpdateAccountStatusEventToState(event);
    }

    if (event is UpdateAccountLocationEvent) {
      yield* _mapUpdateAccountLocationEventToState(event);
    }

    if (event is UpdateAccountLocationEvent) {
      yield* _mapUpdateAccountLocationEventToState(event);
    }

    if (event is UpdateAccountProfilePhotoEvent) {
      yield* _mapUpdateAccountProfilePhotoEventToState(event);
    }
  }

  Stream<AccountState> _mapLoadAccountEventToState(
    LoadAccountEvent event,
  ) async* {
    _accountSubscription?.cancel();

    _accountSubscription =
        _accountsRepository.findByUserId(_userId).listen((accounts) {
      accounts.map((account) {
        add(AccountUpdatedEvent(account));
      });
    });
  }

  Stream<AccountState> _mapAccountUpdatedEventToState(
    AccountUpdatedEvent event,
  ) async* {
    yield AccountState.loaded(event.account);
  }

  Stream<AccountState> _mapUpdateAccountStatusEventToState(
    UpdateAccountStatusEvent event,
  ) async* {
    await _accountsRepository
        .update(state.account.copyWith(status: event.status));
  }

  Stream<AccountState> _mapUpdateAccountLocationEventToState(
    UpdateAccountLocationEvent event,
  ) async* {
    await _accountsRepository
        .update(state.account.copyWith(location: event.location));
  }

  Stream<AccountState> _mapUpdateAccountProfilePhotoEventToState(
    UpdateAccountProfilePhotoEvent event,
  ) async* {
    await _accountsRepository
        .update(state.account.copyWith(photoUrl: event.photoUrl));
  }

  void setStatus(AccountStatus status) {
    add(UpdateAccountStatusEvent(status));
  }

  void updateLocation(Location location) {
    add(UpdateAccountLocationEvent(location));
  }

  void updatePhotoUrl(String photoUrl) {
    add(UpdateAccountProfilePhotoEvent(photoUrl));
  }
}
