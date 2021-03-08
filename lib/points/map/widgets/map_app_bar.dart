import 'package:cookpoint/points/search/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MapAppBar extends StatelessWidget implements PreferredSizeWidget {
  MapAppBar({
    Key key,
    Widget title,
  })  : _appBar = AppBar(
          primary: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          title: title,
        ),
        super(key: key);

  final double _padding = 8.0;

  final double _searchFiltersHeight = 72.00;

  final AppBar _appBar;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        for (var _tag in ['טבעוני', 'צמחוני'])
          BlocBuilder<SearchBloc, SearchState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return InputChip(
                label: Text(_tag),
                onSelected: (selected) =>
                    context.read<SearchBloc>().add(SearchTagSelected(_tag)),
                selected: state.tags.contains(_tag),
              );
            },
          ),
      ],
    );
  }
}
