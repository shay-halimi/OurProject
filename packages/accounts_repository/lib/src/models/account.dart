import 'package:meta/meta.dart';

import '../entities/entities.dart';
import 'location.dart';

@immutable
class Account {
  final String id;
  final String displayName;
  final String photoUrl;
  final String about;
  final String phoneNumber;
  final Location location;
  final bool available;

  const Account({
    @required this.id,
    @required this.displayName,
    @required this.photoUrl,
    @required this.about,
    @required this.phoneNumber,
    @required this.location,
    @required this.available,
  });

  Account copyWith({
    String id,
    String displayName,
    String photoUrl,
    String about,
    String phoneNumber,
    Location location,
    bool available,
  }) {
    return Account(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      about: about ?? this.about,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      available: available ?? this.available,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      displayName.hashCode ^
      photoUrl.hashCode ^
      about.hashCode ^
      phoneNumber.hashCode ^
      location.hashCode ^
      available.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl &&
          about == other.about &&
          phoneNumber == other.phoneNumber &&
          location == other.location &&
          available == other.available;


  @override
  String toString() {
    return 'Account{id: $id, displayName: $displayName, photoUrl: $photoUrl, about: $about, phoneNumber: $phoneNumber, location: $location, available: $available}';
  }

  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      displayName: displayName,
      photoUrl: photoUrl,
      about: about,
      phoneNumber: phoneNumber,
      location: location,
      available: available,
    );
  }

  static Account fromEntity(AccountEntity entity) {
    return Account(
      id: entity.id,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      about: entity.about,
      phoneNumber: entity.phoneNumber,
      location: entity.location,
      available: entity.available,
    );
  }

  static const empty = Account(
    id: '',
    displayName: '',
    photoUrl: 'https://i.pravatar.cc/300',
    about: '',
    phoneNumber: '',
    location: Location.empty,
    available: false,
  );
}
