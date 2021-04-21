import 'package:meta/meta.dart';

import '../entities/entities.dart';
import 'models.dart';

@immutable
class Point {
  const Point({
    @required this.id,
    @required this.cookId,
    @required this.latLng,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.media,
    @required this.tags,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.deletedAt,
  })  : assert(id != null),
        assert(cookId != null),
        assert(latLng != null),
        assert(title != null),
        assert(description != null),
        assert(price != null),
        assert(media != null),
        assert(tags != null),
        assert(createdAt != null),
        assert(updatedAt != null),
        assert(deletedAt != null);

  factory Point.fromEntity(PointEntity entity) {
    return Point(
      id: entity.id,
      cookId: entity.cookId,
      latLng: entity.latLng,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      media: entity.media,
      tags: entity.tags,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
    );
  }

  final String id;

  final String cookId;

  final LatLng latLng;

  final String title;

  final String description;

  final Money price;

  final Set<String> media;

  final Set<String> tags;

  final Time createdAt;

  final Time updatedAt;

  final Time deletedAt;

  static const empty = Point(
    id: '',
    cookId: '',
    latLng: LatLng.empty,
    title: '',
    description: '',
    price: Money.empty,
    media: {},
    tags: {},
    createdAt: Time.empty,
    updatedAt: Time.empty,
    deletedAt: Time.empty,
  );

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;

  bool get isTrashed => deletedAt.isNotEmpty;

  bool get isNotTrashed => !isTrashed;

  Point copyWith({
    String id,
    String cookId,
    LatLng latLng,
    String title,
    String description,
    Money price,
    Set<String> media,
    Set<String> tags,
    Time createdAt,
    Time updatedAt,
    Time deletedAt,
  }) {
    return Point(
      id: id ?? this.id,
      cookId: cookId ?? this.cookId,
      latLng: latLng ?? this.latLng,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      media: media ?? this.media,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'cookId': cookId,
      'latLng': latLng.toJson(),
      'title': title,
      'description': description,
      'price': price.toJson(),
      'media': media,
      'tags': tags,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'deletedAt': deletedAt.toJson(),
    };
  }

  PointEntity toEntity() {
    return PointEntity(
      id: id,
      cookId: cookId,
      latLng: latLng,
      title: title,
      description: description,
      price: price,
      media: media,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  @override
  String toString() {
    return '$Point{id: $id, cookId: $cookId, latLng: $latLng, title: $title, '
        'description: $description, price: $price, media: $media, tags: $tags, '
        'createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cookId == other.cookId &&
          latLng == other.latLng &&
          title == other.title &&
          description == other.description &&
          price == other.price &&
          media == other.media &&
          tags == other.tags &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          deletedAt == other.deletedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      cookId.hashCode ^
      latLng.hashCode ^
      title.hashCode ^
      description.hashCode ^
      price.hashCode ^
      media.hashCode ^
      tags.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
}
