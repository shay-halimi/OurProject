import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:cookpoint/selected_point/selected_point.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MapView extends StatelessWidget {
  const MapView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showPointsBar = context.select((SelectedPointCubit cubit) =>
        cubit.state.point.isNotEmpty && cubit.state.count > 1);
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const _MapViewBody(),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SearchAppBar(),
                Visibility(
                  visible: showPointsBar,
                  child: const PointsBar(),
                )
              ],
            ),
          )
        ],
      ),
      endDrawer: const AppDrawer(),
      floatingActionButton: Visibility(
        visible: !showPointsBar,
        child: const CreatePointButton(),
      ),
    );
  }
}

class _MapViewBody extends StatelessWidget {
  const _MapViewBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (_, state) {
        switch (state.status) {
          case LocationStatus.unknown:
          case LocationStatus.loading:
            return const SplashBody();
          default:
            return MapWidget(
              pixelRatio: MediaQuery.of(context).devicePixelRatio,
            );
        }
      },
    );
  }
}
