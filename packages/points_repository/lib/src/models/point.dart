import 'package:meta/meta.dart';

import '../entities/entities.dart';
import 'models.dart';

@immutable
class Point {
  const Point({
    @required this.id,
    @required this.cookerId,
    @required this.latitude,
    @required this.longitude,
    @required this.relevant,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.media,
    @required this.tags,
  })  : assert(id != null),
        assert(cookerId != null),
        assert(latitude != null),
        assert(longitude != null),
        assert(relevant != null),
        assert(title != null),
        assert(description != null),
        assert(price != null),
        assert(media != null),
        assert(tags != null);

  factory Point.fromEntity(PointEntity entity) {
    return Point(
      id: entity.id,
      cookerId: entity.cookerId,
      latitude: entity.latitude,
      longitude: entity.longitude,
      relevant: entity.relevant,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      media: entity.media,
      tags: entity.tags,
    );
  }

  final String id;
  final String cookerId;
  final double latitude;
  final double longitude;
  final bool relevant;
  final String title;
  final String description;
  final Money price;
  final Set<String> media;
  final Set<String> tags;

  static const empty = Point(
    id: '',
    cookerId: '',
    latitude: 0.0,
    longitude: 0.0,
    relevant: false,
    title: '',
    description: '',
    price: Money.empty,
    media: {},
    tags: {},
  );

  Point copyWith({
    String id,
    String cookerId,
    double latitude,
    double longitude,
    bool relevant,
    String title,
    String description,
    Money price,
    Set<String> media,
    Set<String> tags,
  }) {
    return Point(
      id: id ?? this.id,
      cookerId: cookerId ?? this.cookerId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      relevant: relevant ?? this.relevant,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      media: media ?? this.media,
      tags: tags ?? this.tags,
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'cookerId': cookerId,
      'latitude': latitude,
      'longitude': longitude,
      'relevant': relevant,
      'title': title,
      'description': description,
      'price': price,
      'media': media,
      'tags': tags,
    };
  }

  PointEntity toEntity() {
    return PointEntity(
      id: id,
      cookerId: cookerId,
      latitude: latitude,
      longitude: longitude,
      relevant: relevant,
      title: title,
      description: description,
      price: price,
      media: media,
      tags: tags,
    );
  }

  @override
  String toString() {
    return 'Point{id: $id, cookerId: $cookerId, latitude: $latitude,'
        ' longitude: $longitude, relevant: $relevant,'
        ' title: $title, description: $description,'
        ' price: $price, media: $media, tags: $tags}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cookerId == other.cookerId &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          relevant == other.relevant &&
          title == other.title &&
          description == other.description &&
          price == other.price &&
          media == other.media &&
          tags == other.tags;

  @override
  int get hashCode =>
      id.hashCode ^
      cookerId.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      relevant.hashCode ^
      title.hashCode ^
      description.hashCode ^
      price.hashCode ^
      media.hashCode ^
      tags.hashCode;

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
}
