import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:points_repository/points_repository.dart';

part 'points_event.dart';
part 'points_state.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  PointsBloc({
    @required PointsRepository pointsRepository,
    @required CookBloc cookBloc,
  })  : assert(pointsRepository != null),
        assert(cookBloc != null),
        _pointsRepository = pointsRepository,
        _cookBloc = cookBloc,
        super(const PointsState()) {
    _cookSubscription = _cookBloc.stream.listen((state) {
      if (state.status == CookStatus.loaded && state.cook.isNotEmpty) {
        add(PointsOfCookRequestedEvent(state.cook));
      } else {
        add(PointsOfCookLoadedEvent(const []));
      }
    });
  }

  final PointsRepository _pointsRepository;
  final CookBloc _cookBloc;

  StreamSubscription<List<Point>> _nearbyPointsSubscription;
  StreamSubscription<List<Point>> _cookPointsSubscription;

  StreamSubscription<CookState> _cookSubscription;

  @override
  Future<void> close() {
    _nearbyPointsSubscription?.cancel();
    _cookPointsSubscription?.cancel();
    _cookSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<PointsState> mapEventToState(
    PointsEvent event,
  ) async* {
    if (event is PointsNearbyRequestedEvent) {
      yield* _mapPointsNearbyRequestedEventToState(event);
    } else if (event is PointsNearbyLoadedEvent) {
      yield* _mapPointsNearbyLoadedEventToState(event);
    } else if (event is PointsOfCookRequestedEvent) {
      yield* _mapPointsOfCookRequestedEventToState(event);
    } else if (event is PointsOfCookLoadedEvent) {
      yield* _mapPointsOfCookLoadedEventToState(event);
    } else if (event is PointCreatedEvent) {
      yield* _mapPointCreatedEventToState(event);
    } else if (event is PointUpdatedEvent) {
      yield* _mapPointUpdatedEventToState(event);
    } else if (event is PointDeletedEvent) {
      yield* _mapPointDeletedEventToState(event);
    }
  }

  Stream<PointsState> _mapPointsNearbyRequestedEventToState(
    PointsNearbyRequestedEvent event,
  ) async* {
    if (event.latLng.isEmpty) return;

    final refresh = state.nearbyPoints
        .map((point) => point.latLng)
        .where((latLng) => latLng.distanceInKM(event.latLng) < event.radiusInKM)
        .isEmpty;

    if (!refresh) {
      return;
    }

    yield state.copyWith(status: PointsStatus.loading);

    await _nearbyPointsSubscription?.cancel();

    _nearbyPointsSubscription = _pointsRepository
        .near(latLng: event.latLng, radiusInKM: event.radiusInKM)
        .listen((points) {
      add(PointsNearbyLoadedEvent(
        points
          ..sort((point1, point2) {
            final distance1 = point1.latLng.distanceInKM(event.latLng);
            final distance2 = point2.latLng.distanceInKM(event.latLng);

            if (distance1 == distance2) {
              return 0;
            }

            return distance1 < distance2 ? -1 : 1;
          }),
      ));
    });
  }

  Stream<PointsState> _mapPointsOfCookRequestedEventToState(
      PointsOfCookRequestedEvent event) async* {
    yield state.copyWith(status: PointsStatus.loading);

    await _cookPointsSubscription?.cancel();

    _cookPointsSubscription =
        _pointsRepository.byCookId(event.cook.id).listen((points) {
      final cookLatLng = event.cook.address.toLatLng();

      final dirty = points.where((point) {
        return point.latLng.distanceInKM(cookLatLng) != 0;
      });

      for (var point in dirty) {
        add(PointUpdatedEvent(point.copyWith(latLng: cookLatLng)));
      }

      add(PointsOfCookLoadedEvent(points));
    });
  }

  Stream<PointsState> _mapPointsNearbyLoadedEventToState(
    PointsNearbyLoadedEvent event,
  ) async* {
    yield state.copyWith(
      status: PointsStatus.loaded,
      nearbyPoints: event.points,
    );
  }

  Stream<PointsState> _mapPointsOfCookLoadedEventToState(
    PointsOfCookLoadedEvent event,
  ) async* {
    yield state.copyWith(
      status: PointsStatus.loaded,
      cookPoints: event.points,
    );
  }

  Stream<PointsState> _mapPointCreatedEventToState(
    PointCreatedEvent event,
  ) async* {
    final cook = _cookBloc.state.cook;

    assert(cook.isNotEmpty);

    await _pointsRepository.create(event.point.copyWith(
      cookId: cook.id,
    ));
  }

  Stream<PointsState> _mapPointUpdatedEventToState(
    PointUpdatedEvent event,
  ) async* {
    await _pointsRepository.update(event.point);
  }

  Stream<PointsState> _mapPointDeletedEventToState(
    PointDeletedEvent event,
  ) async* {
    await _pointsRepository.delete(event.point);
  }
}

extension _XAddress on Address {
  LatLng toLatLng() {
    return LatLng(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
