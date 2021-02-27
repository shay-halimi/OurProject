import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:points_repository/points_repository.dart';

part 'points_state.dart';

class PointsCubit extends Cubit<PointsState> {
  PointsCubit({
    @required PointsRepository pointsRepository,
  })  : assert(pointsRepository != null),
        _pointsRepository = pointsRepository,
        super(const PointsInitial());

  final PointsRepository _pointsRepository;

  Future<void> pointChanged(Point point) async {
    await _pointsRepository.set(point);
  }
}
