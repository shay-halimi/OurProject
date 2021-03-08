import 'package:cookpoint/location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocateButton extends StatelessWidget {
  const LocateButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        switch (state.status) {
          case LocationStatus.unknown:
            return ElevatedButton(
              onPressed: () => context.read<LocationCubit>().locate(),
              child: const Icon(Icons.explore),
            );

          case LocationStatus.locating:
            return ElevatedButton(
              onPressed: () => context.read<LocationCubit>().locate(),
              child: const Icon(
                Icons.explore,
                color: Colors.blue,
              ),
            );

          case LocationStatus.located:
            return ElevatedButton(
              onPressed: () => context.read<LocationCubit>().locate(),
              child: const Icon(
                Icons.explore,
                color: Colors.green,
              ),
            );

          case LocationStatus.error:
          default:
            return ElevatedButton(
              onPressed: () => context.read<LocationCubit>().locate(),
              child: const Icon(
                Icons.explore_off,
                color: Colors.red,
              ),
            );
        }
      },
    );
  }
}