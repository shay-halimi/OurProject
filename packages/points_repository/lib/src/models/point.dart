import 'package:meta/meta.dart';

import '../entities/entities.dart';

@immutable
class Point {
  const Point({
    @required this.id,
    @required this.latitude,
    @required this.longitude,
  })  : assert(id != null),
        assert(latitude != null),
        assert(longitude != null);

  factory Point.fromJson(Map<String, Object> map) {
    return Point(
      id: map['id'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  factory Point.fromEntity(PointEntity entity) {
    return Point(
      id: entity.id,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  final String id;
  final double latitude;
  final double longitude;

  Point copyWith({
    String id,
    double latitude,
    double longitude,
  }) {
    return Point(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => id.hashCode ^ latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return 'Point{id: $id, latitude: $latitude, longitude: $longitude}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  PointEntity toEntity() {
    return PointEntity(
      id: id,
      latitude: latitude,
      longitude: longitude,
    );
  }

  static const empty = Point(
    id: '',
    latitude: 0,
    longitude: 0,
  );
}
