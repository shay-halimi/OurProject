import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/search/search.dart';
import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  SearchAppBar({Key key, Widget title, List<Widget> actions})
      : _appBar = AppBar(
          primary: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          title: title,
          actions: actions,
        ),
        super(key: key);

  final double _padding = 8.0;

  final double _searchFiltersHeight = 72.00;

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
              return InputChip(
                label: Text(tag),
                onSelected: (selected) =>
                    context.read<SearchBloc>().add(SearchTagSelected(tag)),
                selected: state.tags.contains(tag),
              );
            },
          ),
      ],
    );
  }
}
