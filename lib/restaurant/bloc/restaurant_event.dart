part of 'restaurant_bloc.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

class RestaurantLoadedEvent extends RestaurantEvent {
  const RestaurantLoadedEvent(this.restaurant);

  final Restaurant restaurant;

  @override
  List<Object> get props => [restaurant];
}

class RestaurantCreatedEvent extends RestaurantEvent {
  const RestaurantCreatedEvent(this.restaurant);

  final Restaurant restaurant;

  @override
  List<Object> get props => [restaurant];
}

class RestaurantUpdatedEvent extends RestaurantEvent {
  const RestaurantUpdatedEvent(this.restaurant);

  final Restaurant restaurant;

  @override
  List<Object> get props => [restaurant];
}
