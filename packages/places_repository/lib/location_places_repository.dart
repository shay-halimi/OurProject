import 'dart:async';

import 'package:location/location.dart';

import 'places_repository.dart';

class LocationPlacesRepository extends PlacesRepository {
  final Location _location = Location();

  @override
  Stream<Place> current() {
    return _location.onLocationChanged.map(
      (data) => Place.empty.copyWith(
        latitude: data.latitude,
        longitude: data.longitude,
      ),
    );
  }

  @override
  Future<void> locate() async {
    await _location.serviceEnabled().then((enabled) {
      if (!enabled) {
        _location.requestService().then((enabled) {
          if (!enabled) {
            throw LocateFailure();
          }
        });
      }
    });

    await _location.hasPermission().then((status) {
      if (status == PermissionStatus.denied ||
          status == PermissionStatus.deniedForever) {
        _location.requestPermission().then((status) {
          if (status == PermissionStatus.denied ||
              status == PermissionStatus.deniedForever) {
            throw LocateFailure();
          }
        });
      }
    });
  }
}
