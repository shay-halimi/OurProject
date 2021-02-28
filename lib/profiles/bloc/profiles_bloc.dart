import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:profiles_repository/profiles_repository.dart';

part 'profiles_event.dart';
part 'profiles_state.dart';

class ProfilesBloc extends Bloc<ProfilesEvent, ProfilesState> {
  ProfilesBloc({
    @required ProfilesRepository profilesRepository,
  })  : assert(profilesRepository != null),
        _profilesRepository = profilesRepository,
        super(const ProfilesState.unknown());

  final ProfilesRepository _profilesRepository;

  StreamSubscription<Profile> _streamSubscription;

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ProfilesState> mapEventToState(ProfilesEvent event) async* {
    if (event is ProfileSubscribedEvent) {
      yield* _mapProfileSubscribedEventToState(event);
    } else if (event is ProfileUpdatedEvent) {
      yield* _mapProfileUpdatedEventToState(event);
    } else if (event is ProfileCreatedEvent) {
      yield* _mapProfileCreatedEventToState(event);
    } else if (event is ProfileLoadedEvent) {
      yield* _mapProfileLoadedEventToState(event);
    }
  }

  Stream<ProfilesState> _mapProfileSubscribedEventToState(
    ProfileSubscribedEvent event,
  ) async* {
    yield const ProfilesState.loading();

    await _streamSubscription?.cancel();

    _streamSubscription =
        _profilesRepository.profile(event.id).listen((profile) {
      add(ProfileLoadedEvent(profile));
    });
  }

  Stream<ProfilesState> _mapProfileLoadedEventToState(
    ProfileLoadedEvent event,
  ) async* {
    if (event.profile == Profile.empty) {
      yield const ProfilesState.empty();
    } else {
      yield ProfilesState.loaded(event.profile);
    }
  }

  Stream<ProfilesState> _mapProfileUpdatedEventToState(
    ProfileUpdatedEvent event,
  ) async* {
    await _profilesRepository.update(event.profile);
  }

  Stream<ProfilesState> _mapProfileCreatedEventToState(
    ProfileCreatedEvent event,
  ) async* {
    await _profilesRepository.create(event.profile);
  }

  void updatePhotoURL(String photoURL) {
    add(ProfileUpdatedEvent(state.profile.copyWith(photoURL: photoURL)));
  }
}
