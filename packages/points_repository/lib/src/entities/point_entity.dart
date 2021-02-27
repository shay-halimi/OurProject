import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:meta/meta.dart';

class PointEntity extends Equatable {
  const PointEntity({
    @required this.id,
    @required this.latitude,
    @required this.longitude,
  });

  factory PointEntity.fromJson(Map<String, Object> map) {
    return PointEntity(
      id: map['id'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  factory PointEntity.fromSnapshot(DocumentSnapshot snap) {
    var point = snap.data()['geoPoint'] as GeoPoint;

    return PointEntity(
      id: snap.id,
      latitude: point.latitude,
      longitude: point.latitude,
    );
  }

  final String id;
  final double latitude;
  final double longitude;

  @override
  List<Object> get props => [id, latitude, longitude];

  @override
  String toString() {
    return 'PointEntity{id: $id, latitude: $latitude, longitude: $longitude}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Map<String, Object> toDocument() {
    return {
      'geoPoint': GeoFirePoint(latitude, longitude).data,
    };
  }
}
