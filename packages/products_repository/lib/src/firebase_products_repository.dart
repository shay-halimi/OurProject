import 'package:cloud_firestore/cloud_firestore.dart';

import 'products_repository.dart';
import 'entities/entities.dart';
import 'models/models.dart';

class FirebaseProductsRepository implements ProductsRepository {
  final collection = FirebaseFirestore.instance.collection('products');

  @override
  Stream<List<Product>> products() {
    return collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromEntity(ProductEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> add(Product product) {
    return collection.add(product.toEntity().toDocument());
  }

  @override
  Future<void> delete(Product product) {
    return collection.doc(product.id).delete();
  }

  @override
  Future<void> update(Product product) {
    return collection.doc(product.id).update(product.toEntity().toDocument());
  }
}
