part of 'profiles_bloc.dart';

enum ProfileStateStatus { loading, loaded, empty, unknown }

class ProfilesState extends Equatable {
  const ProfilesState._({
    this.status = ProfileStateStatus.unknown,
    this.profile = Profile.empty,
  });

  const ProfilesState.loading() : this._(status: ProfileStateStatus.loading);

  const ProfilesState.loaded(Profile profile)
      : this._(status: ProfileStateStatus.loaded, profile: profile);

  const ProfilesState.empty() : this._(status: ProfileStateStatus.empty);

  const ProfilesState.unknown() : this._();

  final ProfileStateStatus status;
  final Profile profile;

  @override
  List<Object> get props => [status, profile];
}
