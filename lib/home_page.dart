import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/bloc/bloc.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/points/search/bloc/search_bloc.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

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
          case LocationStatus.located:
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => PointsBloc(
                    pointsRepository: context.read<PointsRepository>(),
                  )..add(
                      PointsRequestedEvent(LatLng(
                        latitude: state.current.latitude,
                        longitude: state.current.longitude,
                      )),
                    ),
                ),
                BlocProvider(
                  create: (createContext) => SearchBloc(
                    pointsBloc: createContext.read<PointsBloc>(),
                  ),
                ),
                BlocProvider(
                  create: (createContext) => SelectedPointCubit(
                    searchBloc: createContext.read<SearchBloc>(),
                  ),
                ),
              ],
              child: MapView(),
            );
          case LocationStatus.error:
            return LocationPage();
          default:
            return const SplashPage();
        }
      },
    );
  }
}
