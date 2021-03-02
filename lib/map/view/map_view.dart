import 'package:cookpoint/location/cubit/cubit.dart';
import 'package:cookpoint/map/cubit/cubit.dart';
import 'package:cookpoint/map/map.dart';
import 'package:cookpoint/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_services/location_services.dart';

class MapView extends StatelessWidget {
  const MapView({
    Key key,
    @required this.initial,
  }) : super(key: key);

  final Location initial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        key: key,
        title: AppTitle(),
        centerTitle: true,
        actions: [
          BlocBuilder<LocationCubit, LocationState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.status == LocationStateStatus.error
                      ? Icons.location_off
                      : Icons.location_on,
                ),
                onPressed: () => context.read<MapCubit>().focus(state.current),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: BlocBuilder<MapCubit, MapState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state.status == MapStateStatus.loaded) {
            return MapWidget();
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
