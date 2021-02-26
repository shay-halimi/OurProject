import 'package:meta/meta.dart';

import '../entities/entities.dart';
import 'location.dart';

@immutable
class Account {
  final String id;
  final String uid;
  final String displayName;
  final String photoURL;
  final String about;
  final String phoneNumber;
  final Location location;
  final bool available;

  const Account({
    @required this.id,
    @required this.uid,
    @required this.displayName,
    @required this.photoURL,
    @required this.about,
    @required this.phoneNumber,
    @required this.location,
    @required this.available,
  });

  Account copyWith({
    String id,
    String uid,
    String displayName,
    String photoURL,
    String about,
    String phoneNumber,
    Location location,
    bool available,
  }) {
    return Account(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      about: about ?? this.about,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      available: available ?? this.available,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          uid == other.uid &&
          displayName == other.displayName &&
          photoURL == other.photoURL &&
          about == other.about &&
          phoneNumber == other.phoneNumber &&
          location == other.location &&
          available == other.available;

  @override
  int get hashCode =>
      id.hashCode ^
      uid.hashCode ^
      displayName.hashCode ^
      photoURL.hashCode ^
      about.hashCode ^
      phoneNumber.hashCode ^
      location.hashCode ^
      available.hashCode;

  @override
  String toString() {
    return 'Account{id: $id, uid: $uid, displayName: $displayName, photoURL: $photoURL, about: $about, phoneNumber: $phoneNumber, location: $location, available: $available}';
  }

  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      uid: uid,
      displayName: displayName,
      photoURL: photoURL,
      about: about,
      phoneNumber: phoneNumber,
      location: location,
      available: available,
    );
  }

  static Account fromEntity(AccountEntity entity) {
    return Account(
      id: entity.id,
      uid: entity.uid,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
      about: entity.about,
      phoneNumber: entity.phoneNumber,
      location: entity.location,
      available: entity.available,
    );
  }

  static const empty = Account(
    id: '',
    uid: '',
    displayName: '',
    photoURL: 'https://i.pravatar.cc/300',
    about: '',
    phoneNumber: '',
    location: Location.empty,
    available: false,
  );
}
