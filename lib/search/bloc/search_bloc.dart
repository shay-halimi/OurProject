import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/points/points.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
        add(SearchResultsUpdated(state.nearbyPoints));
      } else {
        add(const SearchResultsRequested());
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
    final filtered =
        points.where((point) => point.tags.containsAll(tags)).toList();

    final results = Fuzzy<Point>(
      filtered,
      options: FuzzyOptions(
        findAllMatches: true,
        tokenize: true,
        threshold: 0.2,
        keys: [
          WeightedKey<Point>(
            name: 'title',
            getter: (point) => point.title,
            weight: 100.0,
          ),
          WeightedKey<Point>(
            name: 'description',
            getter: (point) => point.description,
            weight: 50.0,
          ),
        ],
      ),
    ).search(term);

    final cookIds = results.map((r) => r.item.cookId).toSet();

    return cookIds.map((cookId) {
      final result = results.firstWhere((r) => r.item.cookId == cookId);

      return result.item;
    }).toList();
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchResultsRequested) {
      yield state.copyWith(
        status: SearchStatus.loading,
      );
    } else if (event is SearchTermUpdated) {
      await FirebaseAnalytics().logSearch(searchTerm: event.term);

      final results = _filter(
        _nearbyPoints,
        event.term,
        state.tags,
      );

      yield state.copyWith(
        status: SearchStatus.loaded,
        term: event.term,
        results: results,
        selected: results.isEmpty ? Point.empty : results.first,
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

      final results = _filter(
        _nearbyPoints,
        state.term,
        tags,
      );

      yield state.copyWith(
        status: SearchStatus.loaded,
        tags: tags,
        results: results,
        selected: results.isEmpty ? Point.empty : results.first,
      );
    } else if (event is SearchResultsUpdated) {
      final results = _filter(
        event.points,
        state.term,
        state.tags,
      );

      yield state.copyWith(
        status: SearchStatus.loaded,
        results: results,
        selected: results.isEmpty ? Point.empty : results.first,
      );
    } else if (event is SearchResultSelected) {
      await FirebaseAnalytics()
          .logSelectContent(contentType: 'point', itemId: event.selected.id);

      yield state.copyWith(
        status: SearchStatus.loaded,
        selected: event.selected,
      );
    }
  }

  List<Point> get _nearbyPoints => _pointsBloc.state.nearbyPoints;
}
