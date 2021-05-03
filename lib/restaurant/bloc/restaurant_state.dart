part of 'restaurant_bloc.dart';

enum RestaurantStatus { loading, loaded, unknown, error }

class RestaurantState extends Equatable {
  const RestaurantState._({
    this.restaurant = Restaurant.empty,
    this.status = RestaurantStatus.unknown,
  }) : assert(restaurant != null);

  const RestaurantState.loading() : this._(status: RestaurantStatus.loading);

  const RestaurantState.loaded(Restaurant restaurant)
      : this._(status: RestaurantStatus.loaded, restaurant: restaurant);

  const RestaurantState.unknown() : this._();

  const RestaurantState.error() : this._(status: RestaurantStatus.error);

  final Restaurant restaurant;

  final RestaurantStatus status;

  @override
  List<Object> get props => [restaurant, status];
}
