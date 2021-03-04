import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            child: Row(
              children: [
                _searchFilter(
                  icon: const Icon(FontAwesomeIcons.envira),
                  label: const Text('צמחוני'),
                ),

                /// todo<Matan> salad icon
                _searchFilter(
                  icon: const Icon(FontAwesomeIcons.envira),
                  label: const Text('טבעוני'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchFilter({
    Widget icon,
    Widget label,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _padding / 2),
      child: ElevatedButton.icon(
        onPressed: () => null,
        icon: icon,
        label: label,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(_appBar.preferredSize.height + _searchFiltersHeight);
}
