import 'package:meta/meta.dart';

@immutable
class Location {
  final String title;
  final double lan;
  final double lat;

  const Location({
    this.title = '',
    @required this.lan,
    @required this.lat,
  });

  Location copyWith({String title, String lan, String lat}) {
    return Location(
      title: title ?? this.title,
      lan: lan ?? this.lan,
      lat: lat ?? this.lat,
    );
  }

  @override
  int get hashCode => title.hashCode ^ lan.hashCode ^ lat.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          lan == other.lan &&
          lat == other.lat;

  @override
  String toString() {
    return 'Location{title: $title, lan: $lan, lat: $lat}';
  }

  Map<String, Object> toJson() {
    return {
      'title': title,
      'lan': lan,
      'lat': lat,
    };
  }

  static Location fromJson(Map<String, Object> json) {
    return Location(
      title: json['title'] as String,
      lan: (json['lan'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
    );
  }

  static const empty = Location(lan: 0, lat: 0);
}
