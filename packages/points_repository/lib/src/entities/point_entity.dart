import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:meta/meta.dart';
import 'package:points_repository/points_repository.dart';

class PointEntity extends Equatable {
  const PointEntity({
    @required this.id,
    @required this.location,
    @required this.available,
  });

  factory PointEntity.fromJson(Map<String, Object> map) {
    return PointEntity(
      id: map['id'] as String,
      location: Location.fromJson(map['location'] as Map<String, Object>),
      available: map['available'] as bool,
    );
  }

  factory PointEntity.fromSnapshot(DocumentSnapshot snap) {
    final point = snap.data()['location']['geopoint'] as GeoPoint;

    return PointEntity(
      id: snap.id,
      location: Location.empty.copyWith(
        latitude: point?.latitude,
        longitude: point?.longitude,
      ),
      available: snap.data()['available'] as bool,
    );
  }

  final String id;
  final Location location;
  final bool available;

  @override
  List<Object> get props => [id, location, available];

  @override
  String toString() {
    return 'PointEntity{id: $id, location: $location, available: $available}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'location': location.toJson(),
      'available': available,
    };
  }

  Map<String, Object> toDocument() {
    final data = GeoFirePoint(
      location.latitude,
      location.longitude,
    ).data as Map<String, Object>;

    return {
      'location': data,
      'available': available,
    };
  }
}
