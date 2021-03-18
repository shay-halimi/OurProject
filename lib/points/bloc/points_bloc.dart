import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:points_repository/points_repository.dart';

part 'points_event.dart';
part 'points_state.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  PointsBloc({
    @required PointsRepository pointsRepository,
  })  : assert(pointsRepository != null),
        _pointsRepository = pointsRepository,
        super(const PointsState.unknown());

  final PointsRepository _pointsRepository;
  StreamSubscription<List<Point>> _pointsSubscription;

  @override
  Future<void> close() {
    _pointsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<PointsState> mapEventToState(
    PointsEvent event,
  ) async* {
    if (event is PointsRequestedEvent) {
      yield* _mapPointsRequestedEventToState(event);
    } else if (event is PointsOfCookerRequestedEvent) {
      yield* _mapPointsOfCookerRequestedEventToState(event);
    } else if (event is PointsLoadedEvent) {
      yield* _mapPointsLoadedEventToState(event);
    } else if (event is PointCreatedEvent) {
      yield* _mapPointCreatedEventToState(event);
    } else if (event is PointUpdatedEvent) {
      yield* _mapPointUpdatedEventToState(event);
    } else if (event is PointDeletedEvent) {
      yield* _mapPointDeletedEventToState(event);
    }
  }

  Stream<PointsState> _mapPointsRequestedEventToState(
    PointsRequestedEvent event,
  ) async* {
    if (event.latLng.isEmpty) return;

    yield const PointsState.loading();

    await _pointsSubscription?.cancel();

    _pointsSubscription = _pointsRepository
        .near(latLng: event.latLng, radiusInKM: 100)
        .listen((points) {
      add(PointsLoadedEvent(points
        ..sort((point1, point2) {
          final distance1 = point1.latLng.distanceInKM(event.latLng);
          final distance2 = point2.latLng.distanceInKM(event.latLng);

          if (distance1 == distance2) {
            return 0;
          }

          return distance1 < distance2 ? -1 : 1;
        })));
    });
  }

  Stream<PointsState> _mapPointsOfCookerRequestedEventToState(
      PointsOfCookerRequestedEvent event) async* {
    yield const PointsState.loading();

    await _pointsSubscription?.cancel();

    _pointsSubscription =
        _pointsRepository.byCookerId(event.cookerId).listen((points) {
      add(PointsLoadedEvent(points));
    });
  }

  Stream<PointsState> _mapPointsLoadedEventToState(
    PointsLoadedEvent event,
  ) async* {
    yield PointsState.loaded(event.points);
  }

  Stream<PointsState> _mapPointCreatedEventToState(
    PointCreatedEvent event,
  ) async* {
    await _pointsRepository.add(event.point);
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
