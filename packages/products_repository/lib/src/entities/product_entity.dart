import 'package:products_repository/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String supplierId;
  final String title;
  final String description;
  final Money price;
  final Set<String> media;
  final Set<String> tags;

  const ProductEntity({
    this.id,
    this.supplierId,
    this.title,
    this.description,
    this.price,
    this.media,
    this.tags,
  });

  Map<String, Object> toJson() {
    return {
      'id': this.id,
      'supplierId': this.supplierId,
      'title': this.title,
      'description': this.description,
      'price': this.price.toJson(),
      'media': this.media,
      'tags': this.tags,
    };
  }

  @override
  List<Object> get props => [
        id,
        supplierId,
        title,
        description,
        price,
        media,
        tags,
      ];

  @override
  String toString() {
    return 'ProductEntity{id: $id, supplierId: $supplierId, title: $title, description: $description, price: $price, media: $media, tags: $tags}';
  }

  factory ProductEntity.fromJson(Map<String, Object> map) {
    return ProductEntity(
      id: map['id'] as String,
      supplierId: map['supplierId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] as Money,
      media: map['media'] as Set<String>,
      tags: map['tags'] as Set<String>,
    );
  }

  static ProductEntity fromSnapshot(DocumentSnapshot snap) {
    return ProductEntity(
      id: snap.id,
      supplierId: snap.data()['supplierId'] as String,
      title: snap.data()['title'] as String,
      description: snap.data()['description'] as String,
      price: Money.fromJson(snap.data()['price']),
      media: snap.data()['media'] as Set<String>,
      tags: snap.data()['tags'] as Set<String>,
    );
  }

  Map<String, Object> toDocument() {
    return {
      'supplierId': this.supplierId,
      'title': this.title,
      'description': this.description,
      'price': this.price.toJson(),
      'media': this.media,
      'tags': this.tags,
    };
  }
}
