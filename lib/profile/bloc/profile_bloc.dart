import 'dart:async';

import 'package:accounts_repository/accounts_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AccountsRepository _accountsRepository;

  StreamSubscription<List<Account>> _streamSubscription;

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
      yield* _mapProfileRequestedEventToState(event);
    }

    if (event is ProfileLoadedEvent) {
      yield* _mapProfileLoadedEventToState(event);
    }

    if (event is ProfileAvailabilityChangedEvent) {
      yield* _mapProfileAvailabilityChangedEventToState(event);
    }

    if (event is ProfileLocationChangedEvent) {
      yield* _mapProfileLocationChangedEventToState(event);
    }

    if (event is ProfilePhotoUrlChangedEvent) {
      yield* _mapProfilePhotoUrlChangedEventToState(event);
    }
  }

  Stream<ProfileState> _mapProfileRequestedEventToState(
    ProfileRequestedEvent event,
  ) async* {
    _streamSubscription?.cancel();

    _streamSubscription = _accountsRepository
        .findByPhoneNumber(event.phoneNumber)
        .listen((event) {
      event.forEach((element) {
        add(ProfileLoadedEvent(element));
      });
    });
  }

  Stream<ProfileState> _mapProfileLoadedEventToState(
    ProfileLoadedEvent event,
  ) async* {
    yield ProfileState.loaded(event.profile);
  }

  Stream<ProfileState> _mapProfileAvailabilityChangedEventToState(
    ProfileAvailabilityChangedEvent event,
  ) async* {
    _accountsRepository.update(
      state.profile.copyWith(
        available: event.available,
      ),
    );
  }

  Stream<ProfileState> _mapProfileLocationChangedEventToState(
    ProfileLocationChangedEvent event,
  ) async* {
    _accountsRepository.update(
      state.profile.copyWith(
        location: event.location,
      ),
    );
  }

  Stream<ProfileState> _mapProfilePhotoUrlChangedEventToState(
    ProfilePhotoUrlChangedEvent event,
  ) async* {
    _accountsRepository.update(
      state.profile.copyWith(
        photoUrl: event.photoUrl,
      ),
    );
  }

  void setAvailable(bool available) {
    add(ProfileAvailabilityChangedEvent(available));
  }

  void updateLocation(Location location) {
    add(ProfileLocationChangedEvent(location));
  }

  void updatePhotoUrl(String photoUrl) {
    add(ProfilePhotoUrlChangedEvent(photoUrl));
  }
}
