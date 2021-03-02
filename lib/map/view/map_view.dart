import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/map/map.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapView extends StatelessWidget {
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
                icon: const Icon(Icons.my_location),
                onPressed: () =>
                    context.read<MapCubit>().updateLocation(state.current),
              );
            },
          ),
        ],
      ),
      drawer: ThemeDrawer(),
      body: MapWidget(),
    );
  }
}
