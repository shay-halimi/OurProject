part of 'search_bloc.dart';

enum SearchStatus { loading, loaded, unknown, error }

class SearchState extends Equatable {
  const SearchState({
    this.results = const [],
    this.tags = const {},
    this.term = '',
    this.status = SearchStatus.unknown,
  })  : assert(results != null),
        assert(tags != null),
        assert(term != null);

  final List<Point> results;

  final Set<String> tags;

  final String term;

  final SearchStatus status;

  @override
  List<Object> get props => [results, tags, term, status];

  SearchState copyWith({
    SearchStatus status,
    List<Point> results,
    Set<String> tags,
    String term,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      tags: tags ?? this.tags,
      term: term ?? this.term,
    );
  }
}
