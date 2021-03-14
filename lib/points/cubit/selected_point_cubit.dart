import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/points/search/bloc/search_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:points_repository/points_repository.dart';

part 'selected_point_state.dart';

class SelectedPointCubit extends Cubit<SelectedPointState> {
  SelectedPointCubit({@required SearchBloc searchBloc})
      : assert(searchBloc != null),
        _searchBloc = searchBloc,
        super(const SelectedPointState()) {
    _streamSubscription = _searchBloc.listen((state) {
      if (state.results.isNotEmpty && state.term.isNotEmpty) {
        selectPoint(state.results.first);
      }
    });
  }

  final SearchBloc _searchBloc;
  StreamSubscription _streamSubscription;

  void selectPoint(Point point) {
    emit(state.copyWith(point: point));
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
