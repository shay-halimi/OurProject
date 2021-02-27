import 'dart:async';

import 'package:accounts_repository/accounts_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    @required AccountsRepository accountsRepository,
  })  : assert(accountsRepository != null),
        _accountsRepository = accountsRepository,
        super(const ProfileState.unknown());

  final AccountsRepository _accountsRepository;

  StreamSubscription<Account> _streamSubscription;

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileRequestedEvent) {
      yield* _mapProfileRequestedEventToState(event);
    } else if (event is ProfileUpdatedEvent) {
      yield* _mapProfileUpdatedEventToState(event);
    } else if (event is ProfileCreatedEvent) {
      yield* _mapProfileCreatedEventToState(event);
    } else if (event is ProfileLoadedEvent) {
      yield* _mapProfileLoadedEventToState(event);
    }
  }

  Stream<ProfileState> _mapProfileRequestedEventToState(
    ProfileRequestedEvent event,
  ) async* {
    yield const ProfileState.loading();

    await _streamSubscription?.cancel();

    _streamSubscription =
        _accountsRepository.account(event.id).listen((profile) {
      add(ProfileLoadedEvent(profile));
    });
  }

  Stream<ProfileState> _mapProfileLoadedEventToState(
    ProfileLoadedEvent event,
  ) async* {
    if (event.profile == Account.empty) {
      yield const ProfileState.empty();
    } else {
      yield ProfileState.loaded(event.profile);
    }
  }

  Stream<ProfileState> _mapProfileUpdatedEventToState(
    ProfileUpdatedEvent event,
  ) async* {
    await _accountsRepository.update(event.profile);
  }

  Stream<ProfileState> _mapProfileCreatedEventToState(
    ProfileCreatedEvent event,
  ) async* {
    await _accountsRepository.set(event.profile);
  }

  void setAvailable(bool available) {
    add(ProfileUpdatedEvent(state.profile.copyWith(available: available)));
  }

  void updatePhotoURL(String photoURL) {
    add(ProfileUpdatedEvent(state.profile.copyWith(photoURL: photoURL)));
  }
}
