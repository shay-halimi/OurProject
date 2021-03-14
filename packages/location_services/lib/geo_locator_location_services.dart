import 'dart:async';

import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart' as geolocator;

import 'location_services.dart';

class GeoLocatorLocationServices extends LocationServices {
  final StreamController<Location> _locationController = StreamController();

  @override
  Stream<Location> get onLocationChange => _locationController.stream;

  @override
  Future<void> locate() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _locationController.add(Location.empty);
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.deniedForever) {
        return _locationController.add(Location.empty);
      }

      if (permission == geolocator.LocationPermission.denied) {
        return _locationController.add(Location.empty);
      }
    }

    try {
      final data = await geolocator.Geolocator.getCurrentPosition();

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
  Future<Location> fromAddress(String address) async {
    try {
      final value = await geocoding.locationFromAddress(
        address,
        localeIdentifier: 'he_IL',
      );

      if (value.isEmpty) {
        return Location.empty;
      }

      return Location(
        latitude: value.first.latitude,
        longitude: value.first.longitude,
      );
    } on Exception {
      return Location.empty;
    }
  }
}
