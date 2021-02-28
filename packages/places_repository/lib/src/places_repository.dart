library places_repository;

import 'models/place.dart';

class LocateFailure implements Exception {}

abstract class PlacesRepository {
  Stream<Place> current();

  Future<void> locate();
}
