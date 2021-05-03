import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:restaurants_repository/restaurants_repository.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc({
    @required RestaurantsRepository restaurantsRepository,
    @required AuthenticationBloc authenticationBloc,
  })  : assert(restaurantsRepository != null),
        assert(authenticationBloc != null),
        _restaurantsRepository = restaurantsRepository,
        _authenticationBloc = authenticationBloc,
        super(const RestaurantState.unknown()) {
    _authSubscription = _authenticationBloc.stream.listen((state) {
      _restaurantSubscription?.cancel();

      if (state.status == AuthenticationStatus.authenticated) {
        _restaurantSubscription = _restaurantsRepository
            .restaurant(state.user.id)
            .listen((restaurant) {
          add(RestaurantLoadedEvent(restaurant));
        });
      } else {
        add(const RestaurantLoadedEvent(Restaurant.empty));
      }
    });
  }

  final AuthenticationBloc _authenticationBloc;

  final RestaurantsRepository _restaurantsRepository;

  StreamSubscription _authSubscription;

  StreamSubscription<Restaurant> _restaurantSubscription;

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _restaurantSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<RestaurantState> mapEventToState(RestaurantEvent event) async* {
    if (event is RestaurantUpdatedEvent) {
      yield* _mapRestaurantUpdatedEventToState(event);
    } else if (event is RestaurantCreatedEvent) {
      yield* _mapRestaurantCreatedEventToState(event);
    } else if (event is RestaurantLoadedEvent) {
      yield* _mapRestaurantLoadedEventToState(event);
    }
  }

  Stream<RestaurantState> _mapRestaurantLoadedEventToState(
    RestaurantLoadedEvent event,
  ) async* {
    if (event.restaurant.isEmpty) {
      yield const RestaurantState.error();
    } else {
      yield RestaurantState.loaded(event.restaurant);
    }
  }

  Stream<RestaurantState> _mapRestaurantUpdatedEventToState(
    RestaurantUpdatedEvent event,
  ) async* {
    await _restaurantsRepository.update(event.restaurant);
  }

  Stream<RestaurantState> _mapRestaurantCreatedEventToState(
    RestaurantCreatedEvent event,
  ) async* {
    final user = _authenticationBloc.state.user;

    assert(user.isNotEmpty);

    await _restaurantsRepository.create(event.restaurant.copyWith(
      id: user.id,
      phoneNumber: user.phoneNumber,
    ));
  }
}
