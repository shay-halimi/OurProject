part of 'selected_point_cubit.dart';

class SelectedPointState extends Equatable {
  const SelectedPointState({
    this.point = Point.empty,
  }) : assert(point != null);

  final Point point;

  @override
  List<Object> get props => [point];

  SelectedPointState copyWith({
    Point point,
  }) {
    return SelectedPointState(
      point: point ?? this.point,
    );
  }
}
