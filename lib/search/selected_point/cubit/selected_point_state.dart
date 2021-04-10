part of 'selected_point_cubit.dart';

class SelectedPointState extends Equatable {
  const SelectedPointState({
    this.point = Point.empty,
    this.count = 0,
  })  : assert(point != null),
        assert(count != null);

  final Point point;

  final int count;

  @override
  List<Object> get props => [point, count];

  SelectedPointState copyWith({
    Point point,
    int count,
  }) {
    return SelectedPointState(
      point: point ?? this.point,
      count: count ?? this.count,
    );
  }
}
