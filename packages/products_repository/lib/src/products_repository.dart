import 'dart:async';

import 'models/models.dart';

abstract class ProductsRepository {
  Future<void> add(Product product);

  Future<void> delete(Product product);

  Stream<List<Product>> products();

  Future<void> update(Product product);
}
