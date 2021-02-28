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
  StreamSubscription<Point> _pointSubscription;
  StreamSubscription<List<Point>> _pointsSubscription;

  @override
  Future<void> close() {
    _pointSubscription?.cancel();
    _pointsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<PointsState> mapEventToState(
    PointsEvent event,
  ) async* {
    if (event is PointSubscribedEvent) {
      yield* _mapPointSubscribedEventToState(event);
    } else if (event is PointUpdatedEvent) {
      yield* _mapPointLocationUpdatedEventToState(event);
    } else if (event is PointCreatedEvent) {
      yield* _mapPointCreatedEventToState(event);
    } else if (event is PointsLoadedEvent) {
      yield* _mapPointLoadedEventToState(event);
    }
  }

  Stream<PointsState> _mapPointSubscribedEventToState(
    PointSubscribedEvent event,
  ) async* {
    yield const PointsState.loading();

    await _pointSubscription?.cancel();

    _pointSubscription =
        _pointsRepository.point(event.id).listen((point) async {
      await _pointsSubscription?.cancel();
      _pointsSubscription = _pointsRepository.near(point).listen((points) {
        add(PointsLoadedEvent(points));
      });
    });
  }

  Stream<PointsState> _mapPointLocationUpdatedEventToState(
    PointUpdatedEvent event,
  ) async* {
    await _pointsRepository.update(event.point);
  }

  Stream<PointsState> _mapPointCreatedEventToState(
    PointCreatedEvent event,
  ) async* {
    await _pointsRepository.create(event.point);
  }

  Stream<PointsState> _mapPointLoadedEventToState(
    PointsLoadedEvent event,
  ) async* {
    yield PointsState.loaded(event.points);
  }
}
