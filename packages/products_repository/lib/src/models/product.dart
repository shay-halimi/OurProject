import 'package:meta/meta.dart';

import '../entities/entities.dart';
import 'models.dart';

@immutable
class Product {
  const Product({
    @required this.id,
    @required this.supplierId,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.media,
    @required this.tags,
  });

  final String id;
  final String supplierId;
  final String title;
  final String description;
  final Money price;
  final Set<String> media;
  final Set<String> tags;

  Product copyWith({
    String id,
    String supplierId,
    String title,
    String description,
    Money price,
    Set<String> media,
    Set<String> tags,
  }) {
    return Product(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      media: media ?? this.media,
      tags: tags ?? this.tags,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      supplierId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      price.hashCode ^
      media.hashCode ^
      tags.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          supplierId == other.supplierId &&
          title == other.title &&
          description == other.description &&
          price == other.price &&
          media == other.media &&
          tags == other.tags;

  @override
  String toString() {
    return 'Product{id: $id, supplierId: $supplierId, title: $title, '
        'description: $description, price: $price, media: $media, tags: $tags}';
  }

  ProductEntity toEntity() {
    return const ProductEntity();
  }

  static Product fromEntity(ProductEntity entity) {
    return Product(
      id: entity.id,
      supplierId: entity.supplierId,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      media: entity.media,
      tags: entity.tags,
    );
  }

  static const empty = Product(
    id: '',
    supplierId: '',
    title: '',
    description: '',
    price: Money.empty,
    media: {},
    tags: {},
  );
}
