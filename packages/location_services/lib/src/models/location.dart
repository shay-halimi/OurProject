import 'package:meta/meta.dart';

@immutable
class Location {
  const Location(
    double latitude,
    double longitude, [
    this.heading = 0.0,
  ])  : assert(latitude != null),
        assert(longitude != null),
        assert(heading != null),
        latitude =
            (latitude < -90.0 ? -90.0 : (90.0 < latitude ? 90.0 : latitude)),
        longitude = (longitude + 180.0) % 360.0 - 180.0;

  factory Location.fromJson(Map<String, Object> map) {
    return Location(
      (map['latitude'] as num).toDouble(),
      (map['longitude'] as num).toDouble(),
      (map['heading'] as num).toDouble(),
    );
  }

  final double latitude;
  final double longitude;
  final double heading;

  static const empty = Location(0.0, 0.0);

  Location copyWith({
    double latitude,
    double longitude,
    double heading,
  }) {
    return Location(
      latitude ?? this.latitude,
      longitude ?? this.longitude,
      heading ?? this.heading,
    );
  }

  Map<String, Object> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'heading': heading,
    };
  }

  @override
  String toString() {
    return 'Location{'
        'latitude: $latitude, longitude: $longitude, heading: $heading}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          heading == other.heading;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ heading.hashCode;

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
}
