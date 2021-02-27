import 'package:meta/meta.dart';

import '../entities/entities.dart';

@immutable
class Account {
  const Account({
    @required this.id,
    @required this.displayName,
    @required this.photoURL,
    @required this.about,
    @required this.phoneNumber,
    @required this.available,
  });

  factory Account.fromEntity(AccountEntity entity) {
    return Account(
      id: entity.id,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
      about: entity.about,
      phoneNumber: entity.phoneNumber,
      available: entity.available,
    );
  }

  final String id;
  final String displayName;
  final String photoURL;
  final String about;
  final String phoneNumber;
  final bool available;

  Account copyWith({
    String id,
    String displayName,
    String photoURL,
    String about,
    String phoneNumber,
    bool available,
  }) {
    return Account(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      about: about ?? this.about,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      available: available ?? this.available,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          photoURL == other.photoURL &&
          about == other.about &&
          phoneNumber == other.phoneNumber &&
          available == other.available;

  @override
  int get hashCode =>
      id.hashCode ^
      displayName.hashCode ^
      photoURL.hashCode ^
      about.hashCode ^
      phoneNumber.hashCode ^
      available.hashCode;

  @override
  String toString() {
    return 'Account{id: $id, displayName: $displayName, '
        'photoURL: $photoURL, about: $about, phoneNumber: $phoneNumber, '
        'available: $available}';
  }

  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      displayName: displayName,
      photoURL: photoURL,
      about: about,
      phoneNumber: phoneNumber,
      available: available,
    );
  }

  static const empty = Account(
    id: '',
    displayName: '',
    photoURL: 'https://i.pravatar.cc/300',
    about: '',
    phoneNumber: '',
    available: false,
  );
}
