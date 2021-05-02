part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchTermUpdated extends SearchEvent {
  const SearchTermUpdated(this.term);

  final String term;

  @override
  List<Object> get props => [term];
}

class SearchTermCleared extends SearchEvent {
  const SearchTermCleared();

  @override
  List<Object> get props => [];
}

class SearchTagSelected extends SearchEvent {
  const SearchTagSelected(this.tag);

  final String tag;

  @override
  List<Object> get props => [tag];
}

class SearchResultSelected extends SearchEvent {
  const SearchResultSelected(this.selected);

  final Point selected;

  @override
  List<Object> get props => [selected];
}

class SearchResultsUpdated extends SearchEvent {
  const SearchResultsUpdated(this.points);

  final List<Point> points;

  @override
  List<Object> get props => [points];
}

class SearchResultsRequested extends SearchEvent {
  const SearchResultsRequested();

  @override
  List<Object> get props => [];
}
