import 'package:bloc/bloc.dart';
import 'package:cookpoint/points/points.dart';
import 'package:equatable/equatable.dart';

part 'selected_point_state.dart';

class SelectedPointCubit extends Cubit<SelectedPointState> {
  SelectedPointCubit() : super(const SelectedPointState());

  void select(Point point) {
    emit(SelectedPointState(point: point));
  }

  void clear() {
    select(Point.empty);
  }
}
