import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/bloc/bloc.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

import 'map/map.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (_, state) {
        switch (state.status) {
          case LocationStateStatus.located:
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => MapCubit()..updateLocation(state.current),
                ),
                BlocProvider(
                  create: (_) => PointsBloc(
                    pointsRepository: context.read<PointsRepository>(),
                  )..add(
                      PointsRequestedEvent(
                        state.current.latitude,
                        state.current.longitude,
                      ),
                    ),
                ),
              ],
              child: MapView(),
            );
          case LocationStateStatus.error:
            return LocationPage();
          default:
            return const SplashPage();
        }
      },
    );
  }
}
