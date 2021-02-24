part of 'phone_number_cubit.dart';

class PhoneNumberState extends Equatable {
  final PhoneNumber phoneNumber;

  final FormzStatus status;

  const PhoneNumberState({
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = FormzStatus.pure,
  });

  @override
  List<Object> get props => [phoneNumber, status];

  PhoneNumberState copyWith({
    PhoneNumber phoneNumber,
    FormzStatus status,
  }) {
    return PhoneNumberState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }
}
