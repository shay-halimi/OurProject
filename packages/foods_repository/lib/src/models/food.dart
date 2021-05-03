import 'package:meta/meta.dart';

import '../entities/entities.dart';
import 'models.dart';

@immutable
class Food {
  const Food({
    @required this.id,
    @required this.restaurantId,
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
        assert(restaurantId != null),
        assert(latLng != null),
        assert(title != null),
        assert(description != null),
        assert(price != null),
        assert(media != null),
        assert(tags != null),
        assert(createdAt != null),
        assert(updatedAt != null),
        assert(deletedAt != null);

  factory Food.fromEntity(FoodEntity entity) {
    return Food(
      id: entity.id,
      restaurantId: entity.cookId,
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

  final String restaurantId;

  final LatLng latLng;

  final String title;

  final String description;

  final Money price;

  final Set<String> media;

  final Set<String> tags;

  final Time createdAt;

  final Time updatedAt;

  final Time deletedAt;

  static const empty = Food(
    id: '',
    restaurantId: '',
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

  Food copyWith({
    String id,
    String restaurantId,
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
    return Food(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
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
      'restaurantId': restaurantId,
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

  FoodEntity toEntity() {
    return FoodEntity(
      id: id,
      cookId: restaurantId,
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
    return '$Food{id: $id, restaurantId: $restaurantId, latLng: $latLng, '
        'title: $title, description: $description, price: $price, '
        'media: $media, tags: $tags, createdAt: $createdAt, '
        'updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Food &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          restaurantId == other.restaurantId &&
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
      restaurantId.hashCode ^
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
