import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MapPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (_, state) {
        switch (state.status) {
          case LocationStatus.located:
            return MapView();
          case LocationStatus.error:
            return LocationPage();
          default:
            return const SplashPage();
        }
      },
    );
  }
}
