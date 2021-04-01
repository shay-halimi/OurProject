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
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: SearchAppBar(),
      body: const _MapViewBody(),
      endDrawer: AppDrawer(),
      floatingActionButton: Visibility(
        visible: context
            .select((SelectedPointCubit cubit) => cubit.state.point.isEmpty),
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
    return Container(
      color: theme.colorScheme.primary,
      child: BlocBuilder<LocationCubit, LocationState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (_, state) {
          switch (state.status) {
            case LocationStatus.unknown:
            case LocationStatus.loaded:
              return Stack(
                children: [
                  MapWidget(
                    pixelRatio: MediaQuery.of(context).devicePixelRatio,
                  ),
                  SafeArea(
                    child: PointsBar(),
                  ),
                ],
              );
            case LocationStatus.error:
              return SplashBody(
                child: Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(32.0),
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'בכדי להמשיך יש להפעיל את שירותי המיקום במכשירך.',
                              style: theme.textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppButton(
                              child: const Text('נסה/י שוב'),
                              onPressed: context.read<LocationCubit>().locate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            default:
              return const SplashBody();
          }
        },
      ),
    );
  }
}
