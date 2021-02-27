part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileRequestedEvent extends ProfileEvent {
  const ProfileRequestedEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

class ProfileLoadedEvent extends ProfileEvent {
  const ProfileLoadedEvent(this.profile);

  final Account profile;

  @override
  List<Object> get props => [profile];
}

class ProfileCreatedEvent extends ProfileEvent {
  const ProfileCreatedEvent(this.profile);

  final Account profile;

  @override
  List<Object> get props => [profile];
}

class ProfileUpdatedEvent extends ProfileEvent {
  const ProfileUpdatedEvent(this.profile);

  final Account profile;

  @override
  List<Object> get props => [profile];
}
