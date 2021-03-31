import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/points/points.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:points_repository/points_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    @required PointsBloc pointsBloc,
  })  : assert(pointsBloc != null),
        _pointsBloc = pointsBloc,
        super(const SearchState()) {
    _pointsSubscription = pointsBloc.listen((state) {
      if (state.status == PointsStatus.loaded) {
        add(SearchPointsUpdated(state.nearbyPoints));
      }
    });
  }

  final PointsBloc _pointsBloc;
  StreamSubscription _pointsSubscription;

  @override
  Future<void> close() {
    _pointsSubscription?.cancel();
    return super.close();
  }

  List<Point> _filter(List<Point> points, String term, Set<String> tags) {
    return points.where((point) {
      if (point.tags.containsAll(tags)) {
        if (term.isNotEmpty) {
          return point.title.contains(term) || point.description.contains(term);
        }

        return true;
      }

      return false;
    }).toList();
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchTermUpdated) {
      yield state.copyWith(
        status: SearchStatus.loaded,
        term: event.term,
        results: _filter(
          _nearByPoints,
          event.term,
          state.tags,
        ),
      );
    } else if (event is SearchTermCleared) {
      yield* mapEventToState(const SearchTermUpdated(''));
    } else if (event is SearchTagSelected) {
      var tags = {...state.tags};

      if (tags.contains(event.tag)) {
        tags.remove(event.tag);
      } else {
        tags.add(event.tag);
      }

      yield state.copyWith(
        status: SearchStatus.loaded,
        tags: tags,
        results: _filter(
          _nearByPoints,
          state.term,
          tags,
        ),
      );
    } else if (event is SearchPointsUpdated) {
      yield state.copyWith(
        status: SearchStatus.loaded,
        results: _filter(
          event.points,
          state.term,
          state.tags,
        ),
      );
    }
  }

  List<Point> get _nearByPoints => _pointsBloc.state.nearbyPoints;
}
