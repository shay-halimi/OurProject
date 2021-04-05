import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            borderRadius: BorderRadius.circular(8.0),
            elevation: 2.0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const Expanded(child: SearchField()),
                  const _DrawerButton(),
                ],
              ),
            ),
          ),
          const _TagsFilter(),
        ],
      ),
    );
  }
}

class _TagsFilter extends StatelessWidget {
  const _TagsFilter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tags = context.select((SearchBloc search) => search.state.tags);

    return Row(
      children: [
        for (var tag in Point.defaultTags)
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: InputChip(
              label: Text(tag),
              onSelected: (selected) =>
                  context.read<SearchBloc>().add(SearchTagSelected(tag)),
              selected: tags.contains(tag),
              visualDensity: VisualDensity.compact,
            ),
          ),
      ],
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({
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
    final center =
        context.select((LocationCubit location) => location.state.latLng);

    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        if (state.status == SearchStatus.loaded) {
          return BlocListener<SelectedPointCubit, SelectedPointState>(
            listenWhen: (previous, current) =>
                current.point.isEmpty && _focusNode.hasFocus,
            listener: (_, state) {
              _focusNode.unfocus();
            },
            child: TypeAheadField<Point>(
              getImmediateSuggestions: false,
              suggestionsBoxVerticalOffset: 1.0,
              textFieldConfiguration: TextFieldConfiguration(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'מה בא לך לאכול?',
                  suffixIcon: _controller.value.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                              _focusNode.unfocus();
                            });
                            context
                                .read<SearchBloc>()
                                .add(const SearchTermCleared());
                          },
                        )
                      : null,
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {});
                  context.read<SearchBloc>().add(SearchTermUpdated(value));
                },
              ),
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                elevation: 0.0,
              ),
              suggestionsCallback: (pattern) async {
                final points = context.read<SearchBloc>().state.results;

                final cookIds = points.map((point) => point.cookId).toSet();

                return points
                  ..retainWhere((point) => cookIds.remove(point.cookId));
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  key: ValueKey(suggestion.hashCode),
                  title: Text(suggestion.title),
                  trailing: Text(
                    '${suggestion.latLng.toDistance(center)} ק"מ',
                  ),
                );
              },
              noItemsFoundBuilder: (context) {
                return const ListTile(
                  title: Text('אין תוצאות קרובות'),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  _controller.text = suggestion.title;
                });
                context
                    .read<SearchBloc>()
                    .add(SearchTermUpdated(suggestion.title));
                context.read<SelectedPointCubit>().select(suggestion);
              },
            ),
          );
        }

        return const Center(
          child: LinearProgressIndicator(),
        );
      },
    );
  }
}

class _DrawerButton extends StatelessWidget {
  const _DrawerButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: MaterialLocalizations.of(context).openAppDrawerTooltip,
      child: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      ),
    );
  }
}
