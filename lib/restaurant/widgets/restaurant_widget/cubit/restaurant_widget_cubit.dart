import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'restaurant_widget_state.dart';

class RestaurantWidgetCubit extends Cubit<RestaurantWidgetState> {
  RestaurantWidgetCubit({
    @required RestaurantsRepository restaurantsRepository,
    @required String restaurantId,
  })  : assert(restaurantsRepository != null),
        assert(restaurantId != null),
        _restaurantsRepository = restaurantsRepository,
        super(RestaurantWidgetInitial()) {
    _restaurantSubscription =
        _restaurantsRepository.restaurant(restaurantId).listen((event) {
      emit(RestaurantWidgetLoaded(event));
    });
  }

  final RestaurantsRepository _restaurantsRepository;

  StreamSubscription _restaurantSubscription;

  @override
  Future<void> close() {
    _restaurantSubscription?.cancel();
    return super.close();
  }
}
