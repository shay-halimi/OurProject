import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'location_services.dart';

class GeoLocatorLocationServices extends LocationServices {
  final StreamController<Location> _locationController = StreamController();

  @override
  Stream<Location> get onLocationChange => _locationController.stream;

  @override
  Future<void> locate() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _locationController.add(Location.empty);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return _locationController.add(Location.empty);
      }

      if (permission == LocationPermission.denied) {
        return _locationController.add(Location.empty);
      }
    }

    try {
      final data = await Geolocator.getCurrentPosition();

      return _locationController.add(Location(
        latitude: data.latitude,
        longitude: data.longitude,
        heading: data.heading,
      ));
    } on Exception {
      return _locationController.add(Location.empty);
    }
  }

  @override
  Future<String> getAddress(Location location) {
    throw UnimplementedError();
  }
}
