import 'package:cookers_repository/cookers_repository.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

@immutable
class Cooker {
  const Cooker({
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

  factory Cooker.fromEntity(CookerEntity entity) {
    return Cooker(
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

  Cooker copyWith({
    String id,
    String displayName,
    String photoURL,
    String phoneNumber,
    Address address,
  }) {
    return Cooker(
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
      other is Cooker &&
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
    return 'Cooker{id: $id, displayName: $displayName, '
        'photoURL: $photoURL, phoneNumber: $phoneNumber, '
        'address: $address}';
  }

  CookerEntity toEntity() {
    return CookerEntity(
      id: id,
      displayName: displayName,
      photoURL: photoURL,
      phoneNumber: phoneNumber,
      address: address,
    );
  }

  static const empty = Cooker(
    id: '',
    displayName: '',
    photoURL: '',
    phoneNumber: '',
    address: Address.empty,
  );

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
}
