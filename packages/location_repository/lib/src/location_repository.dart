library location_repository;

import 'models/location.dart';

class LocateFailure implements Exception {}

abstract class LocationRepository {
  Stream<Location> current();

  Future<void> locate();
}
