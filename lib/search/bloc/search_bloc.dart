import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/points/points.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:fuzzy/fuzzy.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    @required PointsBloc pointsBloc,
  })  : assert(pointsBloc != null),
        _pointsBloc = pointsBloc,
        super(const SearchState()) {
    _pointsSubscription = pointsBloc.stream.listen((state) {
      if (state.nearbyPoints.isNotEmpty) {
        add(SearchPointsUpdated(state.nearbyPoints));
      } else {
        add(const SearchPointsRequested());
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
    return Fuzzy<Point>(
      points.where((point) => point.tags.containsAll(tags)).toList(),
      options: FuzzyOptions(
        findAllMatches: true,
        tokenize: true,
        threshold: 0.5,
        keys: [
          WeightedKey<Point>(
            name: 'title',
            getter: (point) => point.title,
            weight: 0.5,
          ),
          WeightedKey<Point>(
            name: 'description',
            getter: (point) => point.description,
            weight: 0.5,
          ),
        ],
      ),
    ).search(term).map((result) => result.item).take(100).toList();
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchPointsRequested) {
      yield state.copyWith(
        status: SearchStatus.loading,
      );
    } else if (event is SearchTermUpdated) {
      yield state.copyWith(
        status: SearchStatus.loaded,
        term: event.term,
        results: _filter(
          _nearbyPoints,
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
          _nearbyPoints,
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

  List<Point> get _nearbyPoints => _pointsBloc.state.nearbyPoints;
}
