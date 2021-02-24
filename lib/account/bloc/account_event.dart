part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class LoadAccountEvent extends AccountEvent {
  const LoadAccountEvent();

  @override
  List<Object> get props => [];
}

class AccountUpdatedEvent extends AccountEvent {
  const AccountUpdatedEvent(this.account);

  final Account account;

  @override
  List<Object> get props => [account];
}

class CreateAccountEvent extends AccountEvent {
  const CreateAccountEvent(this.userId, this.phoneNumber);

  final String userId;
  final String phoneNumber;

  @override
  List<Object> get props => [userId, phoneNumber];
}

class UpdateAccountStatusEvent extends AccountEvent {
  const UpdateAccountStatusEvent(this.status);

  final AccountStatus status;

  @override
  List<Object> get props => [status];
}

class UpdateAccountLocationEvent extends AccountEvent {
  const UpdateAccountLocationEvent(this.location);

  final Location location;

  @override
  List<Object> get props => [location];
}

class UpdateAccountProfilePhotoEvent extends AccountEvent {
  const UpdateAccountProfilePhotoEvent(this.photoUrl);

  final String photoUrl;

  @override
  List<Object> get props => [photoUrl];
}
