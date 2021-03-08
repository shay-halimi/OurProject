import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:points_repository/points_repository.dart';

part 'selected_point_state.dart';

class SelectedPointCubit extends Cubit<SelectedPointState> {
  SelectedPointCubit() : super(const SelectedPointState());

  void selectPoint(Point point) {
    emit(state.copyWith(point: point));
  }
}
