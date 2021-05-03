import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/foods/foods.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:fuzzy/fuzzy.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    @required FoodsBloc foodsBloc,
  })  : assert(foodsBloc != null),
        _foodsBloc = foodsBloc,
        super(const SearchState()) {
    _foodsSubscription = foodsBloc.stream.listen((state) {
      if (state.nearbyFoods.isNotEmpty) {
        add(SearchResultsUpdated(state.nearbyFoods));
      } else {
        add(const SearchResultsRequested());
      }
    });
  }

  final FoodsBloc _foodsBloc;

  StreamSubscription _foodsSubscription;

  @override
  Future<void> close() {
    _foodsSubscription?.cancel();
    return super.close();
  }

  List<Food> _filter(List<Food> foods, String term, Set<String> tags) {
    final filtered =
        foods.where((food) => food.tags.containsAll(tags)).toList();

    final results = Fuzzy<Food>(
      filtered,
      options: FuzzyOptions(
        findAllMatches: true,
        tokenize: true,
        threshold: 0.2,
        keys: [
          WeightedKey<Food>(
            name: 'title',
            getter: (food) => food.title,
            weight: 100.0,
          ),
          WeightedKey<Food>(
            name: 'description',
            getter: (food) => food.description,
            weight: 50.0,
          ),
        ],
      ),
    ).search(term);

    final restaurantIds = results.map((r) => r.item.restaurantId).toSet();

    return restaurantIds.map((restaurantId) {
      final result =
          results.firstWhere((r) => r.item.restaurantId == restaurantId);

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
        _nearbyFoods,
        event.term,
        state.tags,
      );

      yield state.copyWith(
        status: SearchStatus.loaded,
        term: event.term,
        results: results,
        selected: results.isEmpty ? Food.empty : results.first,
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
        _nearbyFoods,
        state.term,
        tags,
      );

      yield state.copyWith(
        status: SearchStatus.loaded,
        tags: tags,
        results: results,
        selected: results.isEmpty ? Food.empty : results.first,
      );
    } else if (event is SearchResultsUpdated) {
      final results = _filter(
        event.foods,
        state.term,
        state.tags,
      );

      yield state.copyWith(
        status: SearchStatus.loaded,
        results: results,
        selected: results.isEmpty ? Food.empty : results.first,
      );
    } else if (event is SearchResultSelected) {
      await FirebaseAnalytics()
          .logSelectContent(contentType: 'food', itemId: event.selected.id);

      yield state.copyWith(
        status: SearchStatus.loaded,
        selected: event.selected,
      );
    }
  }

  List<Food> get _nearbyFoods => _foodsBloc.state.nearbyFoods;
}
