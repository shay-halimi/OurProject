import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'selected_point_state.dart';

class SelectedPointCubit extends Cubit<SelectedPointState> {
  SelectedPointCubit({
    @required SearchBloc searchBloc,
  })  : assert(searchBloc != null),
        _searchBloc = searchBloc,
        super(const SelectedPointState()) {
    _searchBlocSubscription = _searchBloc.stream.listen((state) {
      if (state.status == SearchStatus.loaded) {
        if (!state.results
            .map((point) => point.id)
            .contains(this.state.point.id)) {
          select(state.results.first);
        }
      } else {
        clear(0);
      }
    });
  }

  final SearchBloc _searchBloc;

  StreamSubscription _searchBlocSubscription;

  @override
  Future<void> close() {
    _searchBlocSubscription?.cancel();
    return super.close();
  }

  void select(Point point, [int count]) {
    emit(state.copyWith(
      point: point,
      count: count ?? state.count + 1,
    ));
  }

  void clear([int count]) {
    select(Point.empty, count);
  }
}
