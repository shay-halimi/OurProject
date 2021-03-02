import 'package:meta/meta.dart';

import '../entities/entities.dart';

@immutable
class Point {
  const Point({
    @required this.id,
    @required this.available,
    @required this.latitude,
    @required this.longitude,
  })  : assert(id != null),
        assert(available != null),
        assert(latitude != null),
        assert(longitude != null);

  factory Point.fromJson(Map<String, Object> map) {
    return Point(
      id: map['id'] as String,
      available: map['available'] as bool,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  factory Point.fromEntity(PointEntity entity) {
    return Point(
      id: entity.id,
      available: entity.available,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  final String id;
  final bool available;
  final double latitude;
  final double longitude;

  static const empty = Point(
    id: '',
    available: false,
    latitude: 0,
    longitude: 0,
  );

  Point copyWith({
    String id,
    bool available,
    double latitude,
    double longitude,
  }) {
    return Point(
      id: id ?? this.id,
      available: available ?? this.available,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'available': available,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  PointEntity toEntity() {
    return PointEntity(
      id: id,
      available: available,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  String toString() {
    return 'Point{id: $id, available: $available, '
        'latitude: $latitude, longitude: $longitude}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          available == other.available &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode =>
      id.hashCode ^ available.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
