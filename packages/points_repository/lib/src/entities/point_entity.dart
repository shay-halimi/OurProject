import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:meta/meta.dart';

class PointEntity extends Equatable {
  const PointEntity({
    @required this.id,
    @required this.available,
    @required this.latitude,
    @required this.longitude,
  });

  factory PointEntity.fromJson(Map<String, Object> map) {
    return PointEntity(
      id: map['id'] as String,
      available: map['available'] as bool,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  factory PointEntity.fromSnapshot(DocumentSnapshot snap) {
    final geoPoint = snap.data()[geoPointField]['geopoint'] as GeoPoint;

    return PointEntity(
      id: snap.id,
      available: snap.data()['available'] as bool,
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
    );
  }

  static const String geoPointField = 'geo_point';

  final String id;
  final bool available;
  final double latitude;
  final double longitude;

  @override
  List<Object> get props => [id, available, latitude, longitude];

  Map<String, Object> toJson() {
    return {
      'id': id,
      'available': available,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Map<String, Object> toDocument() {
    final geoPoint = GeoFirePoint(
      latitude,
      longitude,
    ).data as Map<String, Object>;

    return {
      'available': available,
      geoPointField: geoPoint,
    };
  }
}
