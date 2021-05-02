part of 'search_bloc.dart';

enum SearchStatus { loading, loaded, unknown, error }

class SearchState extends Equatable {
  const SearchState({
    this.results = const [],
    this.selected = Point.empty,
    this.tags = const {},
    this.term = '',
    this.status = SearchStatus.unknown,
  })  : assert(results != null),
        assert(selected != null),
        assert(tags != null),
        assert(term != null);

  final List<Point> results;

  final Point selected;

  final Set<String> tags;

  final String term;

  final SearchStatus status;

  @override
  List<Object> get props => [results, selected, tags, term, status];

  SearchState copyWith({
    SearchStatus status,
    List<Point> results,
    Point selected,
    Set<String> tags,
    String term,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      selected: selected ?? this.selected,
      tags: tags ?? this.tags,
      term: term ?? this.term,
    );
  }
}
