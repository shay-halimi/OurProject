part of 'foods_bloc.dart';

enum FoodsStatus { loading, loaded, unknown, error }

class FoodsState extends Equatable {
  const FoodsState({
    this.nearbyFoods = const [],
    this.restaurantFoods = const [],
    this.status = FoodsStatus.unknown,
  })  : assert(nearbyFoods != null),
        assert(restaurantFoods != null);

  final List<Food> nearbyFoods;

  final List<Food> restaurantFoods;

  final FoodsStatus status;

  @override
  List<Object> get props => [nearbyFoods, restaurantFoods, status];

  FoodsState copyWith({
    List<Food> nearbyFoods,
    List<Food> restaurantFoods,
    FoodsStatus status,
  }) {
    return FoodsState(
      nearbyFoods: nearbyFoods ?? this.nearbyFoods,
      restaurantFoods: restaurantFoods ?? this.restaurantFoods,
      status: status ?? this.status,
    );
  }
}
