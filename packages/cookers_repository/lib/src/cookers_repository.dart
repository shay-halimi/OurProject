import 'dart:async';

import 'models/models.dart';

abstract class CookersRepository {
  Stream<Cooker> cooker(String id);

  Future<void> create(Cooker cooker);

  Future<void> update(Cooker cooker);
}
