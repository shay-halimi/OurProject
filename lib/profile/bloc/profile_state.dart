part of 'profile_bloc.dart';

enum ProfileStateStatus { loading, loaded, empty, created, unknown }

class ProfileState extends Equatable {
  const ProfileState._({
    this.status = ProfileStateStatus.unknown,
    this.profile = Account.empty,
  });

  const ProfileState.loading() : this._(status: ProfileStateStatus.loading);

  const ProfileState.loaded(Account profile)
      : this._(status: ProfileStateStatus.loaded, profile: profile);

  const ProfileState.empty() : this._(status: ProfileStateStatus.empty);

  const ProfileState.created() : this._(status: ProfileStateStatus.created);

  const ProfileState.unknown() : this._();

  final ProfileStateStatus status;
  final Account profile;

  @override
  List<Object> get props => [status, profile];
}
