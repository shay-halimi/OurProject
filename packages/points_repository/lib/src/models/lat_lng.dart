import 'package:meta/meta.dart';

@immutable
class LatLng {
  const LatLng({
    @required this.latitude,
    @required this.longitude,
  })  : assert(latitude != null),
        assert(longitude != null);

  factory LatLng.fromJson(Map<String, Object> map) {
    return LatLng(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  final double latitude;
  final double longitude;

  LatLng copyWith({
    double latitude,
    double longitude,
  }) {
    return LatLng(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLng &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return 'LatLng{latitude: $latitude, longitude: $longitude}';
  }

  Map<String, Object> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static const empty = LatLng(latitude: 0, longitude: 0);

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
}
