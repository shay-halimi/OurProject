import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:dough/dough.dart';
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
          SearchField(),
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
    final tags = context.select((SearchBloc bloc) => bloc.state.tags);

    return Row(
      children: [
        for (var tag in Point.defaultTags)
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: InputChip(
              label: Text(
                tag,
                style: theme.textTheme.bodyText2,
              ),
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
  SearchField({
    Key key,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final center = context.select((LocationCubit cubit) => cubit.state);

    return Material(
      borderRadius: BorderRadius.circular(8.0),
      elevation: 2.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TypeAheadField<Point>(
                getImmediateSuggestions: true,
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'מה בא לך לאכול?',
                    suffixIcon: _controller.value.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              context
                                  .read<SearchBloc>()
                                  .add(const SearchTermCleared());
                              context.read<SelectedPointCubit>().clear();
                              _controller.clear();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                  ),
                ),
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  elevation: 0.0,
                ),
                suggestionsCallback: (pattern) async {
                  context.read<SearchBloc>().add(SearchTermUpdated(pattern));
                  return context.read<SearchBloc>().suggestions;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    key: ValueKey(suggestion.hashCode),
                    title: Text(suggestion.title),
                    trailing: Text(
                      '${suggestion.latLng.toDistance(center.latLng)} ק"מ',
                    ),
                  );
                },
                noItemsFoundBuilder: (context) {
                  return const ListTile(
                    title: Text('לא נמצאו תוצאות'),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _controller.text = suggestion.title;
                  context.read<SelectedPointCubit>().select(suggestion);
                },
              ),
            ),
            _DrawerButton(
              child: context.select((SearchBloc bloc) =>
                      bloc.state.status == SearchStatus.loading)
                  ? const CircularProgressIndicator(strokeWidth: 8.0)
                  : const Icon(Icons.menu),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerButton extends StatelessWidget {
  const _DrawerButton({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: MaterialLocalizations.of(context).openAppDrawerTooltip,
      child: PressableDough(
        child: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        onReleased: (details) {
          if (details.delta.distance >= 200) {
            return context.read<LocationCubit>().locate();
          }
        },
      ),
    );
  }
}
