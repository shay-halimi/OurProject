import 'dart:async';

import 'package:accounts_repository/accounts_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AccountsRepository _accountsRepository;

  StreamSubscription<Account> _streamSubscription;

  ProfileBloc({
    @required AccountsRepository accountsRepository,
  })  : assert(accountsRepository != null),
        _accountsRepository = accountsRepository,
        super(const ProfileState.unknown());

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileRequestedEvent) {
      yield* _mapProfileRequestedToState(event);
    } else if (event is ProfileUpdatedEvent) {
      yield* _mapProfileUpdatedEventToState(event);
    } else if (event is ProfileLoadedEvent) {
      yield* _mapProfileLoadedToState(event);
    }
  }

  Stream<ProfileState> _mapProfileRequestedToState(
    ProfileRequestedEvent event,
  ) async* {
    yield ProfileState.loading();

    _streamSubscription?.cancel();

    _streamSubscription =
        _accountsRepository.account(event.id).listen((profile) {
      add(ProfileLoadedEvent(profile));
    });
  }

  Stream<ProfileState> _mapProfileLoadedToState(
    ProfileLoadedEvent event,
  ) async* {
    if (event.profile == Account.empty) {
      yield ProfileState.empty();
    } else {
      yield ProfileState.loaded(event.profile);
    }
  }

  Stream<ProfileState> _mapProfileUpdatedEventToState(
    ProfileUpdatedEvent event,
  ) async* {
    yield ProfileState.loading();

    _accountsRepository.set(event.profile);
  }

  void setAvailable(bool available) {
    add(ProfileUpdatedEvent(state.profile.copyWith(available: available)));
  }

  void updateLocation(Location location) {
    add(ProfileUpdatedEvent(state.profile.copyWith(location: location)));
  }

  void updatePhotoURL(String photoURL) {
    add(ProfileUpdatedEvent(state.profile.copyWith(photoURL: photoURL)));
  }
}
