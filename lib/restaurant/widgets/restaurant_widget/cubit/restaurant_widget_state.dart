part of 'restaurant_widget_cubit.dart';

@immutable
abstract class RestaurantWidgetState extends Equatable {
  @override
  List<Object> get props => [];
}

class RestaurantWidgetInitial extends RestaurantWidgetState {}

class RestaurantWidgetLoaded extends RestaurantWidgetState {
  RestaurantWidgetLoaded(this.restaurant);

  final Restaurant restaurant;

  @override
  List<Object> get props => [restaurant];
}
