import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:places_repository/places_repository.dart';

part 'places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  PlacesCubit({
    @required PlacesRepository placesRepository,
  })  : assert(placesRepository != null),
        _placesRepository = placesRepository,
        super(const PlacesState.unknown()) {
    _placeSubscription = _placesRepository.current().listen((event) {
      emit(PlacesState.located(event));
    });
  }

  final PlacesRepository _placesRepository;

  StreamSubscription<Place> _placeSubscription;

  @override
  Future<void> close() {
    _placeSubscription?.cancel();
    return super.close();
  }

  Future<void> locate() async {
    emit(const PlacesState.locating());

    try {
      await _placesRepository.locate();
    } on LocateFailure {
      emit(const PlacesState.error());
    }
  }
}
