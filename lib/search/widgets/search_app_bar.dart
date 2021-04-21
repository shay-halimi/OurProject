import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:cookpoint/selected_point/selected_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
        (SearchBloc search) => search.state.status != SearchStatus.loaded);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                        width: 16,
                        height: 16,
                      ),
                    ),
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
    final tags = {
      Tag.vegan: S.of(context).vegan,
      Tag.vegetarian: S.of(context).vegetarian,
      Tag.glutenFree: S.of(context).glutenFree,
      Tag.kosher: S.of(context).kosher,
    };

    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        if (state.status == SearchStatus.loaded) {
          final textTheme = Theme.of(context).textTheme;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var tag in tags.entries)
                  Padding(
                    key: Key(tag.value),
                    padding: const EdgeInsets.only(left: 2.0),
                    child: InputChip(
                      elevation: 2.0,
                      selectedColor: Colors.white,
                      backgroundColor: Colors.white,
                      label: Text(
                        tag.value,
                        style: textTheme.bodyText2,
                      ),
                      onSelected: (_) => context
                          .read<SearchBloc>()
                          .add(SearchTagSelected(tag.key.title)),
                      selected: state.tags.contains(tag.key.title),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
          );
        }

        return Container();
      },
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
        context.select((LocationCubit location) => location.state.toLatLng());

    return BlocListener<SelectedPointCubit, SelectedPointState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) {
        if (state.point.isEmpty && _focusNode.hasFocus) {
          setState(() {
            _focusNode.unfocus();
          });
        }
      },
      child: TypeAheadField<Point>(
        getImmediateSuggestions: false,
        suggestionsBoxVerticalOffset: 1.0,
        textFieldConfiguration: TextFieldConfiguration(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: S.of(context).searchHintText,
            suffixIcon: _controller.value.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                        _focusNode.unfocus();
                      });
                      context.read<SearchBloc>().add(const SearchTermCleared());
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
        suggestionsCallback: (_) async {
          return context.read<SearchBloc>().state.results;
        },
        itemBuilder: (_, point) {
          return ListTile(
            key: ValueKey(point.id),
            title: Text(point.title),
            trailing: Text(
              '${humanz.distance(point.latLng, center)} '
              '${S.of(context).km}',
              style: Theme.of(context).textTheme.caption,
            ),
          );
        },
        noItemsFoundBuilder: (_) {
          return ListTile(
            title: Text(S.of(context).searchNoPointsFound),
          );
        },
        onSuggestionSelected: (point) {
          setState(() {});
          context.read<SelectedPointCubit>().select(point);
        },
      ),
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
