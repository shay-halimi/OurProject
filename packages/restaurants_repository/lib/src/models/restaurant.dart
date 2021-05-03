import 'package:meta/meta.dart';

import '../entities/entities.dart';
import 'models.dart';

@immutable
class Restaurant {
  const Restaurant({
    @required this.id,
    @required this.displayName,
    @required this.photoURL,
    @required this.phoneNumber,
    @required this.about,
    @required this.address,
  })  : assert(id != null),
        assert(displayName != null),
        assert(photoURL != null),
        assert(phoneNumber != null),
        assert(about != null),
        assert(address != null);

  factory Restaurant.fromEntity(RestaurantEntity entity) {
    return Restaurant(
      id: entity.id,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
      phoneNumber: entity.phoneNumber,
      about: entity.about,
      address: entity.address,
    );
  }

  final String id;
  final String displayName;
  final String photoURL;
  final String phoneNumber;
  final String about;
  final Address address;

  Restaurant copyWith({
    String id,
    String displayName,
    String photoURL,
    String phoneNumber,
    String about,
    Address address,
  }) {
    return Restaurant(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      about: about ?? this.about,
      address: address ?? this.address,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Restaurant &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          photoURL == other.photoURL &&
          phoneNumber == other.phoneNumber &&
          about == other.about &&
          address == other.address;

  @override
  int get hashCode =>
      id.hashCode ^
      displayName.hashCode ^
      photoURL.hashCode ^
      phoneNumber.hashCode ^
      about.hashCode ^
      address.hashCode;

  @override
  String toString() {
    return '$Restaurant{id: $id, displayName: $displayName, '
        'photoURL: $photoURL, phoneNumber: $phoneNumber, '
        'about: $about, address: $address}';
  }

  RestaurantEntity toEntity() {
    return RestaurantEntity(
      id: id,
      displayName: displayName,
      photoURL: photoURL,
      phoneNumber: phoneNumber,
      about: '',
      address: address,
    );
  }

  static const empty = Restaurant(
    id: '',
    displayName: '',
    photoURL: '',
    phoneNumber: '',
    about: '',
    address: Address.empty,
  );

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
}
