import 'package:meta/meta.dart';

import '../entities/entities.dart';
import 'models.dart';

@immutable
class Cook {
  const Cook({
    @required this.id,
    @required this.displayName,
    @required this.photoURL,
    @required this.phoneNumber,
    @required this.address,
  })  : assert(id != null),
        assert(displayName != null),
        assert(photoURL != null),
        assert(phoneNumber != null),
        assert(address != null);

  factory Cook.fromEntity(CookEntity entity) {
    return Cook(
      id: entity.id,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
    );
  }

  final String id;

  final String displayName;

  final String photoURL;

  final String phoneNumber;

  final Address address;

  Cook copyWith({
    String id,
    String displayName,
    String photoURL,
    String phoneNumber,
    Address address,
  }) {
    return Cook(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cook &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          photoURL == other.photoURL &&
          phoneNumber == other.phoneNumber &&
          address == other.address;

  @override
  int get hashCode =>
      id.hashCode ^
      displayName.hashCode ^
      photoURL.hashCode ^
      phoneNumber.hashCode ^
      address.hashCode;

  @override
  String toString() {
    return 'Cook{id: $id, displayName: $displayName, '
        'photoURL: $photoURL, phoneNumber: $phoneNumber, '
        'address: $address}';
  }

  CookEntity toEntity() {
    return CookEntity(
      id: id,
      displayName: displayName,
      photoURL: photoURL,
      phoneNumber: phoneNumber,
      address: address,
    );
  }

  static const empty = Cook(
    id: '',
    displayName: '',
    photoURL: '',
    phoneNumber: '',
    address: Address.empty,
  );

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
}
