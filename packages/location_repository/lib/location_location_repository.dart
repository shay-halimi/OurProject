import 'dart:async';

import 'package:location/location.dart' as lib;

import 'location_repository.dart';

class LocationLocationRepository extends LocationRepository {
  LocationLocationRepository() {
    _streamSubscription = _lib.onLocationChanged.listen(_onRawData);
  }

  final lib.Location _lib = lib.Location();

  final StreamController<Location> _streamController = StreamController();

  StreamSubscription<lib.LocationData> _streamSubscription;

  @override
  Stream<Location> current() {
    return _streamController.stream;
  }

  @override
  Future<void> locate() async {
    await _lib.serviceEnabled().then((enabled) {
      if (!enabled) {
        _lib.requestService().then((enabled) {
          if (!enabled) {
            throw LocateFailure();
          }
        });
      }
    });

    await _lib.hasPermission().then((status) {
      if (status == lib.PermissionStatus.denied ||
          status == lib.PermissionStatus.deniedForever) {
        _lib.requestPermission().then((status) {
          if (status == lib.PermissionStatus.denied ||
              status == lib.PermissionStatus.deniedForever) {
            throw LocateFailure();
          }
        });
      }
    });

    await _streamSubscription?.cancel();

    _streamSubscription = _lib.onLocationChanged.listen(_onRawData);
  }

  void _onRawData(lib.LocationData data) {
    _streamController.add(Location.empty.copyWith(
      latitude: data.latitude,
      longitude: data.longitude,
    ));
  }
}
