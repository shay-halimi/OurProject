part of 'points_bar_cubit.dart';

enum PointsBarStatus { scrollable, disable }

class PointsBarState extends Equatable {
  const PointsBarState._({
    this.status = PointsBarStatus.disable,
  }) : assert(status != null);

  const PointsBarState.scrollable()
      : this._(status: PointsBarStatus.scrollable);

  const PointsBarState.disable() : this._(status: PointsBarStatus.disable);

  final PointsBarStatus status;

  @override
  List<Object> get props => [status];
}
