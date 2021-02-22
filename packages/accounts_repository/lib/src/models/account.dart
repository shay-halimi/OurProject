import 'package:meta/meta.dart';
import '../entities/entities.dart';
import 'location.dart';

enum AccountStatus { closed, open }

@immutable
class Account {
  final String id;
  final String userId;
  final String displayName;
  final String profilePhoto;
  final String about;
  final String phoneNumber;
  final Location location;
  final AccountStatus status;

  const Account({
    @required this.id,
    @required this.userId,
    @required this.displayName,
    @required this.profilePhoto,
    @required this.about,
    @required this.phoneNumber,
    @required this.location,
    @required this.status,
  });

  Account copyWith({
    String id,
    String userId,
    String displayName,
    String profilePhoto,
    String about,
    String phoneNumber,
    Location location,
    AccountStatus status,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      about: about ?? this.about,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      status: status ?? this.status,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      displayName.hashCode ^
      profilePhoto.hashCode ^
      about.hashCode ^
      phoneNumber.hashCode ^
      location.hashCode ^
      status.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          displayName == other.displayName &&
          profilePhoto == other.profilePhoto &&
          about == other.about &&
          phoneNumber == other.phoneNumber &&
          location == other.location &&
          status == other.status;

  @override
  String toString() {
    return 'Account { id: $id, userId: $userId, displayName: $displayName, profilePhoto: $profilePhoto, about: $about, phoneNumber: $phoneNumber, location: $location, status: $status}';
  }

  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      userId: userId,
      displayName: displayName,
      profilePhoto: profilePhoto,
      about: about,
      phoneNumber: phoneNumber,
      location: location,
      status: status.index,
    );
  }

  static Account fromEntity(AccountEntity entity) {
    return Account(
      id: entity.id,
      userId: entity.userId,
      displayName: entity.displayName,
      profilePhoto: entity.profilePhoto,
      about: entity.about,
      phoneNumber: entity.phoneNumber,
      location: entity.location,
      status: AccountStatus.values[entity.status],
    );
  }

  static const empty = Account(
    id: '',
    userId: '',
    displayName: '',
    profilePhoto: '',
    about: '',
    phoneNumber: '',
    location: Location.empty,
    status: AccountStatus.closed,
  );
}
