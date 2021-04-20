import 'dart:async';

import 'package:geocoding/geocoding.dart' as geo_coding;
import 'package:geolocator/geolocator.dart' as geo_locator;

import 'location_services.dart';

class GeoLocatorLocationServices extends LocationServices {
  final StreamController<Location> _locationController = StreamController();

  @override
  Stream<Location> get onLocationChange => _locationController.stream;

  @override
  Future<void> locate([bool openSettings = false]) async {
    try {
      final serviceEnabled =
          await geo_locator.Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('location service disabled');
      }

      var permission = await geo_locator.Geolocator.checkPermission();

      if (permission == geo_locator.LocationPermission.denied) {
        permission = await geo_locator.Geolocator.requestPermission();

        if (permission == geo_locator.LocationPermission.deniedForever) {
          if (openSettings && (await _openSettings())) {
            return locate(false);
          }

          throw Exception('location permission denied forever');
        }

        if (permission == geo_locator.LocationPermission.denied) {
          throw Exception('location permission denied');
        }
      }

      final data = await geo_locator.Geolocator.getCurrentPosition();

      return _locationController.add(Location(
        data.latitude,
        data.longitude,
        data.heading,
      ));
    } on Exception {
      return _locationController.add(Location.empty);
    } on Error {
      return _locationController.add(Location.empty);
    }
  }

  @override
  Future<Location> fromAddress(String address) async {
    try {
      final value = await geo_coding.locationFromAddress(address);

      if (value.isEmpty) {
        return Location.empty;
      }

      return Location(
        value.first.latitude,
        value.first.longitude,
      );
    } on Exception {
      return Location.empty;
    }
  }

  Future<bool> _openSettings() async =>
      await geo_locator.Geolocator.openAppSettings() ||
      await geo_locator.Geolocator.openLocationSettings();
}
