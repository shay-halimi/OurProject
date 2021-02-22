part of 'user_account_bloc.dart';

abstract class UserAccountEvent extends Equatable {
  const UserAccountEvent();

  @override
  List<Object> get props => [];
}

class FetchUserAccountEvent extends UserAccountEvent {
  const FetchUserAccountEvent();

  @override
  List<Object> get props => [];
}

class CreateUserAccountEvent extends UserAccountEvent {
  const CreateUserAccountEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserAccountStatusEvent extends UserAccountEvent {
  const UpdateUserAccountStatusEvent(this.status);

  final AccountStatus status;

  @override
  List<Object> get props => [status];
}

class UpdateUserAccountLocationEvent extends UserAccountEvent {
  const UpdateUserAccountLocationEvent(this.location);

  final Location location;

  @override
  List<Object> get props => [location];
}
