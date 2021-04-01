import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  SearchAppBar({Key key})
      : _appBar = AppBar(
          primary: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          title: SearchField(),
        ),
        super(key: key);

  final double _padding = 8.0;

  final double _searchFiltersHeight = 64.00;

  final AppBar _appBar;

  @override
  Widget build(BuildContext context) {
    return PressableDough(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + _padding,
              right: _padding,
              left: _padding,
              bottom: _padding,
            ),
            child: Column(
              children: [
                _appBar,
                Padding(
                  padding: EdgeInsets.only(top: _padding),
                  child: const _TagsFilter(),
                ),
              ],
            ),
          ),
        ],
      ),
      onReleased: (details) {
        if (details.delta.distance >= 200) {
          return context.read<LocationCubit>().locate();
        }
      },
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(_appBar.preferredSize.height + _searchFiltersHeight);
}

class _TagsFilter extends StatelessWidget {
  const _TagsFilter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var tag in Point.defaultTags)
          BlocBuilder<SearchBloc, SearchState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: InputChip(
                  label: Text(
                    tag,
                    style: theme.textTheme.bodyText2,
                  ),
                  onSelected: (selected) =>
                      context.read<SearchBloc>().add(SearchTagSelected(tag)),
                  selected: state.tags.contains(tag),
                  visualDensity: VisualDensity.compact,
                ),
              );
            },
          ),
      ],
    );
  }
}

class SearchField extends StatefulWidget {
  SearchField({
    Key key,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suggestions =
        context.select((PointsBloc bloc) => bloc.state.nearbyPoints);

    final center =
        context.select((LocationCubit cubit) => cubit.state).toLatLng();

    return Row(
      children: [
        Expanded(
          child: TypeAheadField<Point>(
            getImmediateSuggestions: true,
            textFieldConfiguration: TextFieldConfiguration(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'מה בא לך לאכול?',
                suffixIcon: context
                        .select((SearchBloc bloc) => bloc.state.term)
                        .isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          context
                              .read<SearchBloc>()
                              .add(const SearchTermCleared());
                          _controller.clear();
                        },
                      )
                    : null,
              ),
            ),
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              elevation: 0.0,
            ),
            suggestionsCallback: (pattern) {
              return suggestions
                  .where((point) => point.title.contains(pattern))
                  .toSet();
            },
            itemBuilder: (context, suggestion) {
              final km =
                  suggestion.latLng.distanceInKM(center).toStringAsFixed(1);
              return ListTile(
                title: Text(suggestion.title),
                trailing: Text('$km ק"מ'),
              );
            },
            noItemsFoundBuilder: (context) {
              return const ListTile(
                title: Text('לא נמצאו תוצאות'),
              );
            },
            onSuggestionSelected: (suggestion) {
              _controller.text = suggestion.title;
              context
                  .read<SearchBloc>()
                  .add(SearchTermUpdated(suggestion.title));
            },
          ),
        ),
        if (context.select(
            (PointsBloc bloc) => bloc.state.status == PointsStatus.loading))
          Container(
            child: const CircularProgressIndicator(),
            width: 16,
            height: 16,
          ),
      ],
    );
  }
}

extension _XLocationState on LocationState {
  LatLng toLatLng() {
    return LatLng(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
