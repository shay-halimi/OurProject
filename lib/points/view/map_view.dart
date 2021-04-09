import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final point =
        context.select((SelectedPointCubit cubit) => cubit.state.point);
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
                SearchAppBar(),
                Visibility(
                  visible: point.isNotEmpty,
                  child: const PointsBar(),
                )
              ],
            ),
          )
        ],
      ),
      endDrawer: AppDrawer(),
      floatingActionButton: Visibility(
        visible: point.isEmpty,
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
