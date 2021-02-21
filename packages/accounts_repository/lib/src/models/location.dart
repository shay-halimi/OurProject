import 'package:meta/meta.dart';

@immutable
class Location {
  final String id;
  final String title;
  final double lan;
  final double lat;

  const Location({
    this.id,
    this.title,
    this.lan,
    this.lat,
  });

  Location copyWith({bool id, String title, String lan, String lat}) {
    return Location(
      id: id ?? this.id,
      title: title ?? this.title,
      lan: id ?? this.lan,
      lat: id ?? this.lat,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ lan.hashCode ^ lat.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          lan == other.lan &&
          lat == other.lat &&
          id == other.id;

  @override
  String toString() {
    return 'Location{id: $id, title: $title, lan: $lan, lat: $lat}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'title': title,
      'lan': lan,
      'lat': lat,
    };
  }

  static Location fromJson(Map<String, Object> json) {
    return Location(
      id: json['id'] as String,
      title: json['title'] as String,
      lan: (json['lan'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
    );
  }
}
