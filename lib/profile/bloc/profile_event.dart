part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileRequestedEvent extends ProfileEvent {
  const ProfileRequestedEvent(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object> get props => [];
}

class ProfileLoadedEvent extends ProfileEvent {
  const ProfileLoadedEvent(this.profile);

  final Account profile;

  @override
  List<Object> get props => [profile];
}

class ProfileAvailabilityChangedEvent extends ProfileEvent {
  const ProfileAvailabilityChangedEvent(this.available);

  final bool available;

  @override
  List<Object> get props => [available];
}

class ProfileLocationChangedEvent extends ProfileEvent {
  const ProfileLocationChangedEvent(this.location);

  final Location location;

  @override
  List<Object> get props => [location];
}

class ProfilePhotoUrlChangedEvent extends ProfileEvent {
  const ProfilePhotoUrlChangedEvent(this.photoUrl);

  final String photoUrl;

  @override
  List<Object> get props => [photoUrl];
}

class ProfileDisplayNameChangedEvent extends ProfileEvent {
  const ProfileDisplayNameChangedEvent(this.displayName);

  final String displayName;

  @override
  List<Object> get props => [displayName];
}

class ProfileAboutChangedEvent extends ProfileEvent {
  const ProfileAboutChangedEvent(this.about);

  final String about;

  @override
  List<Object> get props => [about];
}