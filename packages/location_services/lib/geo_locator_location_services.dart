import 'dart:async';

import 'package:geocoding/geocoding.dart' as geo_coding;
import 'package:geolocator/geolocator.dart' as geo_locator;

import 'location_services.dart';

class GeoLocatorLocationServices extends LocationServices {
  final StreamController<Location> _locationController = StreamController();

  @override
  Stream<Location> get onLocationChange => _locationController.stream;

  @override
  Future<void> locate() async {
    geo_locator.LocationPermission permission;

    try {
      bool serviceEnabled;
      serviceEnabled = await geo_locator.Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return _locationController.add(Location.empty);
      }
    } on UnimplementedError {
      print('web?');
    }

    permission = await geo_locator.Geolocator.checkPermission();
    if (permission == geo_locator.LocationPermission.denied) {
      permission = await geo_locator.Geolocator.requestPermission();
      if (permission == geo_locator.LocationPermission.deniedForever) {
        return _locationController.add(Location.empty);
      }

      if (permission == geo_locator.LocationPermission.denied) {
        return _locationController.add(Location.empty);
      }
    }

    try {
      final data = await geo_locator.Geolocator.getCurrentPosition();

      return _locationController.add(Location(
        data.latitude,
        data.longitude,
        data.heading,
      ));
    } on Exception {
      return _locationController.add(Location.empty);
    }
  }

  @override
  Future<Location> fromAddress(String address) async {
    try {
      final value = await geo_coding.locationFromAddress(
        address,
        localeIdentifier: 'he_IL',
      );

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
}
