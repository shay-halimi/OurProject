import 'package:meta/meta.dart';

@immutable
class Location {
  final double latitude;
  final double longitude;

  const Location({
    @required this.latitude,
    @required this.longitude,
  });

  Location copyWith({String latitude, String longitude}) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  String toString() {
    return 'Location{latitude: $latitude, longitude: $longitude}';
  }

  Map<String, Object> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static Location fromJson(Map<String, Object> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  static const empty = const Location(latitude: 0, longitude: 0);
}
