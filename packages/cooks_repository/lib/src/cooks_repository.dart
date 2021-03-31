import 'dart:async';

import 'models/models.dart';

abstract class CooksRepository {
  Stream<Cook> cook(String id);

  Future<void> create(Cook cook);

  Future<void> update(Cook cook);
}
