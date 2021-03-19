part of 'search_bloc.dart';

enum SearchStatus { loading, loaded, unknown, error }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.unknown,
    this.results = const [],
    this.tags = const {},
    this.term = '',
  });

  final SearchStatus status;
  final List<Point> results;
  final Set<String> tags;
  final String term;

  @override
  List<Object> get props => [status, results, tags, term];

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
