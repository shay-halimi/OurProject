import 'package:meta/meta.dart';

import '../entities/entities.dart';

@immutable
class Profile {
  const Profile({
    @required this.id,
    @required this.displayName,
    @required this.photoURL,
    @required this.about,
    @required this.phoneNumber,
  });

  factory Profile.fromEntity(ProfileEntity entity) {
    return Profile(
      id: entity.id,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
      about: entity.about,
      phoneNumber: entity.phoneNumber,
    );
  }

  final String id;
  final String displayName;
  final String photoURL;
  final String about;
  final String phoneNumber;

  Profile copyWith({
    String id,
    String displayName,
    String photoURL,
    String about,
    String phoneNumber,
  }) {
    return Profile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      about: about ?? this.about,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          photoURL == other.photoURL &&
          about == other.about &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode =>
      id.hashCode ^
      displayName.hashCode ^
      photoURL.hashCode ^
      about.hashCode ^
      phoneNumber.hashCode;

  @override
  String toString() {
    return 'Profile{id: $id, displayName: $displayName, '
        'photoURL: $photoURL, about: $about, phoneNumber: $phoneNumber}';
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      displayName: displayName,
      photoURL: photoURL,
      about: about,
      phoneNumber: phoneNumber,
    );
  }

  static const empty = Profile(
    id: '',
    displayName: '',
    photoURL: 'https://i.pravatar.cc/300',
    about: '',
    phoneNumber: '',
  );
}
