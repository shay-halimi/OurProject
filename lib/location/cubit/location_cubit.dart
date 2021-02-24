import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart' as _location;
import 'package:meta/meta.dart';

part 'location.dart';

class LocationCubit extends Cubit<Location> {

  _location.Location location = new _location.Location();

  StreamSubscription<_location.LocationData> _listen;

  LocationCubit() : super(Location.empty) {
    _listen = location.onLocationChanged.listen((event) {

      emit(Location(latitude: event.latitude, longitude: event.longitude));

    });
  }

  Future<void> fetchUserLocation() async {
    emit(await _getUserLocation());
  }

  Future<Location> _getUserLocation() async {

    bool _serviceEnabled;
    _location.PermissionStatus _permissionGranted;
    _location.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Location.empty;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == _location.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != _location.PermissionStatus.granted) {
        return Location.empty;
      }
    }

    _locationData = await location.getLocation();

    return Location(
      longitude: _locationData.longitude,
      latitude: _locationData.latitude,
    );
  }

  @override
  Future<void> close() {
    _listen.cancel();
    return super.close();
  }
}
