import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/search/search.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:points_repository/points_repository.dart';

part 'selected_point_state.dart';

class SelectedPointCubit extends Cubit<SelectedPointState> {
  SelectedPointCubit({
    @required SearchBloc searchBloc,
  })  : assert(searchBloc != null),
        _searchBloc = searchBloc,
        super(const SelectedPointState()) {
    _searchBlocSubscription = _searchBloc.listen((state) {
      if (state.results.isNotEmpty &&
          (state.term.isNotEmpty || state.tags.isNotEmpty)) {
        select(state.results.first);
      } else {
        clear();
      }
    });
  }

  final SearchBloc _searchBloc;
  StreamSubscription _searchBlocSubscription;

  void select(Point point) {
    emit(SelectedPointState(
      point: point,
    ));
  }

  void clear() {
    select(Point.empty);
  }

  @override
  Future<void> close() {
    _searchBlocSubscription?.cancel();
    return super.close();
  }
}
