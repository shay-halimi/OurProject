import 'package:meta/meta.dart';

import '../entities/entities.dart';

@immutable
class Cooker {
  const Cooker({
    @required this.id,
    @required this.displayName,
    @required this.photoURL,
    @required this.phoneNumber,
  });

  factory Cooker.fromEntity(CookerEntity entity) {
    return Cooker(
      id: entity.id,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
      phoneNumber: entity.phoneNumber,
    );
  }

  final String id;
  final String displayName;
  final String photoURL;
  final String phoneNumber;

  Cooker copyWith({
    String id,
    String displayName,
    String photoURL,
    String phoneNumber,
  }) {
    return Cooker(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
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
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode =>
      id.hashCode ^
      displayName.hashCode ^
      photoURL.hashCode ^
      phoneNumber.hashCode;

  @override
  String toString() {
    return 'Cooker{id: $id, displayName: $displayName, '
        'photoURL: $photoURL, phoneNumber: $phoneNumber}';
  }

  CookerEntity toEntity() {
    return CookerEntity(
      id: id,
      displayName: displayName,
      photoURL: photoURL,
      phoneNumber: phoneNumber,
    );
  }

  static const empty = Cooker(
    id: '',
    displayName: '',
    photoURL: 'https://i.pravatar.cc/300',
    phoneNumber: '',
  );

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
}
