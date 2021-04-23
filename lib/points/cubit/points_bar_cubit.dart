import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'points_bar_state.dart';

class PointsBarCubit extends Cubit<PointsBarState> {
  PointsBarCubit() : super(const PointsBarState.disable());

  void enable() {
    emit(const PointsBarState.scrollable());
  }

  void disable() {
    emit(const PointsBarState.disable());
  }
}
