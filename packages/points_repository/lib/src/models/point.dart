import 'package:meta/meta.dart';

import '../entities/entities.dart';
import 'models.dart';

@immutable
class Point {
  const Point({
    @required this.id,
    @required this.location,
    @required this.available,
  })  : assert(id != null),
        assert(location != null),
        assert(available != null);

  factory Point.fromJson(Map<String, Object> map) {
    return Point(
      id: map['id'] as String,
      location: Location.fromJson(map['location'] as Map<String, Object>),
      available: map['available'] as bool,
    );
  }

  factory Point.fromEntity(PointEntity entity) {
    return Point(
      id: entity.id,
      location: entity.location,
      available: entity.available,
    );
  }

  final String id;
  final Location location;
  final bool available;

  Point copyWith({
    String id,
    Location location,
    bool available,
  }) {
    return Point(
      id: id ?? this.id,
      location: location ?? this.location,
      available: available ?? this.available,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          location == other.location &&
          available == other.available;

  @override
  int get hashCode => id.hashCode ^ location.hashCode ^ available.hashCode;

  @override
  String toString() {
    return 'Point{id: $id, location: $location, available: $available}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'location': location.toJson(),
      'available': available,
    };
  }

  PointEntity toEntity() {
    return PointEntity(
      id: id,
      location: location,
      available: available,
    );
  }

  static const empty = Point(
    id: '',
    location: Location.empty,
    available: false,
  );
}
