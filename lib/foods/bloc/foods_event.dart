part of 'foods_bloc.dart';

abstract class FoodsEvent extends Equatable {
  const FoodsEvent();

  @override
  List<Object> get props => [];
}

class FoodsNearbyRequestedEvent extends FoodsEvent {
  const FoodsNearbyRequestedEvent(
    this.latLng, [
    this.radiusInKM = 100,
  ]);

  final LatLng latLng;

  final double radiusInKM;

  @override
  List<Object> get props => [latLng, radiusInKM];
}

class FoodsNearbyLoadedEvent extends FoodsEvent {
  FoodsNearbyLoadedEvent(this.foods);

  final List<Food> foods;

  @override
  List<Object> get props => [foods];
}

class FoodsOfRestaurantRequestedEvent extends FoodsEvent {
  const FoodsOfRestaurantRequestedEvent(this.restaurant);

  final Restaurant restaurant;

  @override
  List<Object> get props => [restaurant];
}

class FoodsOfRestaurantLoadedEvent extends FoodsEvent {
  FoodsOfRestaurantLoadedEvent(this.foods);

  final List<Food> foods;

  @override
  List<Object> get props => [foods];
}

class FoodCreatedEvent extends FoodsEvent {
  const FoodCreatedEvent(this.food);

  final Food food;

  @override
  List<Object> get props => [food];
}

class FoodUpdatedEvent extends FoodsEvent {
  const FoodUpdatedEvent(this.food);

  final Food food;

  @override
  List<Object> get props => [food];
}

class FoodDeletedEvent extends FoodsEvent {
  const FoodDeletedEvent(this.food);

  final Food food;

  @override
  List<Object> get props => [food];
}

class FoodRestoreEvent extends FoodsEvent {
  const FoodRestoreEvent(this.food);

  final Food food;

  @override
  List<Object> get props => [food];
}
