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

class SearchTagSelected extends SearchEvent {
  const SearchTagSelected(this.tag);

  final String tag;

  @override
  List<Object> get props => [tag];
}

class SearchPointsUpdated extends SearchEvent {
  const SearchPointsUpdated(this.points);

  final List<Point> points;

  @override
  List<Object> get props => [points];
}
