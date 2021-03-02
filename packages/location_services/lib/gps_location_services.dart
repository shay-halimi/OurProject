import 'dart:async';

import 'package:location/location.dart' as gps;

import 'location_services.dart';

class GPSLocationServices extends LocationServices {
  GPSLocationServices() {
    _locationController
      ..onListen = locate
      ..onCancel = () {
        _timer?.cancel();
      };
  }

  final gps.Location _gps = gps.Location();

  final StreamController<Location> _locationController = StreamController();

  Timer _timer;

  @override
  Stream<Location> get onLocationChange => _locationController.stream;

  @override
  Future<void> locate() async {
    _timer?.cancel();

    bool _serviceEnabled;
    gps.PermissionStatus _permissionGranted;

    _serviceEnabled = await _gps.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _gps.requestService();
      if (!_serviceEnabled) {
        return _locationController.add(Location.empty);
      }
    }

    _permissionGranted = await _gps.hasPermission();
    if (_permissionGranted == gps.PermissionStatus.denied) {
      _permissionGranted = await _gps.requestPermission();
      if (_permissionGranted != gps.PermissionStatus.granted) {
        return _locationController.add(Location.empty);
      }
    }

    try {
      final data = await _gps.getLocation();

      _timer = Timer(const Duration(seconds: 1), locate);

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
