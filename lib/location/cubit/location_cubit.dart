import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/cook/bloc/bloc.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/points/points.dart';
import 'package:equatable/equatable.dart';
import 'package:location_services/location_services.dart';
import 'package:meta/meta.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({
    @required LocationServices locationServices,
    @required CookBloc cookBloc,
  })  : assert(locationServices != null),
        assert(cookBloc != null),
        _locationServices = locationServices,
        _cookBloc = cookBloc,
        super(const LocationState.unknown()) {
    _locationSubscription =
        _locationServices.onLocationChange.listen((location) {
      if (location.isEmpty) {
        emit(LocationState.error(_getDefaultLocation()));
      } else {
        emit(LocationState.loaded(location));
      }
    });
  }

  final CookBloc _cookBloc;

  final LocationServices _locationServices;

  StreamSubscription<Location> _locationSubscription;

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }

  Future<void> locate([bool openSettings = false]) async {
    emit(const LocationState.loading());

    await _locationServices.locate(openSettings);
  }

  Location _getDefaultLocation() {
    final address = _cookBloc.state.cook.address;

    if (address.isEmpty) {
      /// @TODO(Matan) detect user country \ state ..
      /// @TODO(Matan) check in preferences.

      /// Be'er Shevao
      return const Location(31.2431906939, 34.7931751606);
    }

    return address.toLocation();
  }
}

extension _XAddress on Address {
  Location toLocation() {
    return Location(latitude, longitude);
  }
}
