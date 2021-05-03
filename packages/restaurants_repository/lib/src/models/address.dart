import 'package:meta/meta.dart';

@immutable
class Address {
  const Address({
    @required this.name,
    @required this.latitude,
    @required this.longitude,
  })  : assert(name != null),
        assert(latitude != null),
        assert(longitude != null);

  factory Address.fromJson(Map<String, Object> map) {
    return Address(
      name: map['name'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  final String name;

  final double latitude;

  final double longitude;

  static const empty = Address(
    name: '',
    latitude: 0,
    longitude: 0,
  );

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;

  Address copyWith({
    String name,
    double latitude,
    double longitude,
  }) {
    return Address(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, Object> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return '$Address{name: $name, latitude: $latitude, longitude: $longitude}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => name.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
