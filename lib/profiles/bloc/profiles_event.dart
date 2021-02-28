part of 'profiles_bloc.dart';

abstract class ProfilesEvent extends Equatable {
  const ProfilesEvent();

  @override
  List<Object> get props => [];
}

class ProfileSubscribedEvent extends ProfilesEvent {
  const ProfileSubscribedEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

class ProfileLoadedEvent extends ProfilesEvent {
  const ProfileLoadedEvent(this.profile);

  final Profile profile;

  @override
  List<Object> get props => [profile];
}

class ProfileCreatedEvent extends ProfilesEvent {
  const ProfileCreatedEvent(this.profile);

  final Profile profile;

  @override
  List<Object> get props => [profile];
}

class ProfileUpdatedEvent extends ProfilesEvent {
  const ProfileUpdatedEvent(this.profile);

  final Profile profile;

  @override
  List<Object> get props => [profile];
}
