import 'package:meta/meta.dart';
import '../entities/entities.dart';
import 'location.dart';

@immutable
class Account {
  final String id;
  final String userId;
  final String displayName;
  final String profilePhoto;
  final String about;
  final String phoneNumber;
  final Location location;
  final bool open;

  const Account({
    this.id,
    this.userId,
    this.displayName,
    this.profilePhoto,
    this.about,
    this.phoneNumber,
    this.location,
    this.open,
  });

  Account copyWith({
    String id,
    String userId,
    String displayName,
    String profilePhoto,
    String about,
    String phoneNumber,
    Location location,
    bool open,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      about: about ?? this.about,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      open: open ?? this.open,
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
      open.hashCode;

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
          open == other.open;

  @override
  String toString() {
    return 'Account { id: $id, userId: $userId, displayName: $displayName, profilePhoto: $profilePhoto, about: $about, phoneNumber: $phoneNumber, location: $location, open: $open}';
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
      open: open,
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
      open: entity.open,
    );
  }
}
