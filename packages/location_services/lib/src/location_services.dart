library location_services;

import 'models/models.dart';

abstract class LocationServices {
  Stream<Location> get onLocationChange;

  Future<void> locate();

  Future<String> getAddress(Location location);
}
