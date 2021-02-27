import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/location/cubit/cubit.dart';
import 'package:cookpoint/map/map.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/profile/profile.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    context.read<ProfileBloc>().add(ProfileRequestedEvent(user.id));

    return BlocListener<LocationCubit, LocationState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) async {
        if (state.status == LocationStateStatus.located) {
          final point = Point.empty.copyWith(
            id: user.id,
            latitude: state.location.latitude,
            longitude: state.location.longitude,
          );

          await context.read<PointsCubit>().pointChanged(point);
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          switch (state.status) {
            case ProfileStateStatus.loading:
              return SplashPage();
              break;
            case ProfileStateStatus.loaded:
              return BlocProvider(
                create: (_) => MapCubit(),
                child: MapPage(),
              );
              break;
            case ProfileStateStatus.empty:
              return CreateProfilePage();
              break;
            default:
              return const Text('unknown');
              break;
          }
        },
      ),
    );
  }
}
