import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/map/view/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MapPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        switch (state.status) {
          case LocationStateStatus.located:
            return MapView(
              initial: state.current,
            );
          case LocationStateStatus.error:
            return LocationPage();
          default:
            return Scaffold(
              body: Center(
                child: Text(state.toString()),
              ),
            );
        }
      },
    );
  }
}
