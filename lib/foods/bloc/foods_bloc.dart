import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:equatable/equatable.dart';
import 'package:foods_repository/foods_repository.dart';
import 'package:meta/meta.dart';

part 'foods_event.dart';
part 'foods_state.dart';

class FoodsBloc extends Bloc<FoodsEvent, FoodsState> {
  FoodsBloc({
    @required FoodsRepository foodsRepository,
    @required RestaurantBloc restaurantBloc,
  })  : assert(foodsRepository != null),
        assert(restaurantBloc != null),
        _foodsRepository = foodsRepository,
        _restaurantBloc = restaurantBloc,
        super(const FoodsState()) {
    _restaurantSubscription = _restaurantBloc.stream.listen((state) {
      if (state.status == RestaurantStatus.loaded) {
        add(FoodsOfRestaurantRequestedEvent(state.restaurant));
      } else {
        add(FoodsOfRestaurantLoadedEvent(const []));
      }
    });
  }

  final FoodsRepository _foodsRepository;

  final RestaurantBloc _restaurantBloc;

  StreamSubscription<List<Food>> _nearbyFoodsSubscription;

  StreamSubscription<List<Food>> _restaurantFoodsSubscription;

  StreamSubscription<RestaurantState> _restaurantSubscription;

  @override
  Future<void> close() {
    _nearbyFoodsSubscription?.cancel();
    _restaurantFoodsSubscription?.cancel();
    _restaurantSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<FoodsState> mapEventToState(
    FoodsEvent event,
  ) async* {
    if (event is FoodsNearbyRequestedEvent) {
      yield* _mapFoodsNearbyRequestedEventToState(event);
    } else if (event is FoodsNearbyLoadedEvent) {
      yield* _mapFoodsNearbyLoadedEventToState(event);
    } else if (event is FoodsOfRestaurantRequestedEvent) {
      yield* _mapFoodsOfRestaurantRequestedEventToState(event);
    } else if (event is FoodsOfRestaurantLoadedEvent) {
      yield* _mapFoodsOfRestaurantLoadedEventToState(event);
    } else if (event is FoodCreatedEvent) {
      yield* _mapFoodCreatedEventToState(event);
    } else if (event is FoodUpdatedEvent) {
      yield* _mapFoodUpdatedEventToState(event);
    } else if (event is FoodDeletedEvent) {
      yield* _mapFoodDeletedEventToState(event);
    } else if (event is FoodRestoreEvent) {
      yield* _mapFoodRestoreEventToState(event);
    }
  }

  Stream<FoodsState> _mapFoodsNearbyRequestedEventToState(
    FoodsNearbyRequestedEvent event,
  ) async* {
    if (event.latLng.isEmpty) return;

    yield state.copyWith(status: FoodsStatus.loading);

    await _nearbyFoodsSubscription?.cancel();

    _nearbyFoodsSubscription = _foodsRepository
        .near(latLng: event.latLng, radiusInKM: event.radiusInKM)
        .listen((nearbyFoods) {
      add(FoodsNearbyLoadedEvent(nearbyFoods));
    });
  }

  Stream<FoodsState> _mapFoodsOfRestaurantRequestedEventToState(
      FoodsOfRestaurantRequestedEvent event) async* {
    yield state.copyWith(status: FoodsStatus.loading);

    await _restaurantFoodsSubscription?.cancel();

    _restaurantFoodsSubscription = _foodsRepository
        .byRestaurantId(event.restaurant.id)
        .listen((restaurantFoods) {
      final restaurantLatLng = event.restaurant.address.toLatLng();

      final dirty = restaurantFoods.where((restaurantFood) {
        return restaurantFood.latLng != restaurantLatLng;
      });

      for (var restaurantFood in dirty) {
        add(FoodUpdatedEvent(
            restaurantFood.copyWith(latLng: restaurantLatLng)));
      }

      add(FoodsOfRestaurantLoadedEvent(restaurantFoods));
    });
  }

  Stream<FoodsState> _mapFoodsNearbyLoadedEventToState(
    FoodsNearbyLoadedEvent event,
  ) async* {
    yield state.copyWith(
      status: FoodsStatus.loaded,
      nearbyFoods: event.foods,
    );
  }

  Stream<FoodsState> _mapFoodsOfRestaurantLoadedEventToState(
    FoodsOfRestaurantLoadedEvent event,
  ) async* {
    yield state.copyWith(
      status: FoodsStatus.loaded,
      restaurantFoods: event.foods,
    );
  }

  Stream<FoodsState> _mapFoodCreatedEventToState(
    FoodCreatedEvent event,
  ) async* {
    final restaurant = _restaurantBloc.state.restaurant;

    assert(restaurant.isNotEmpty);

    await _foodsRepository.create(event.food.copyWith(
      restaurantId: restaurant.id,
    ));
  }

  Stream<FoodsState> _mapFoodUpdatedEventToState(
    FoodUpdatedEvent event,
  ) async* {
    await _foodsRepository.update(event.food);
  }

  Stream<FoodsState> _mapFoodDeletedEventToState(
    FoodDeletedEvent event,
  ) async* {
    await _foodsRepository.delete(event.food);
  }

  Stream<FoodsState> _mapFoodRestoreEventToState(
    FoodRestoreEvent event,
  ) async* {
    await _foodsRepository.restore(event.food);
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
