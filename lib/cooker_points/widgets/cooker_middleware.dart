import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/points/bloc/bloc.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

class CookerMiddleware extends StatelessWidget {
  const CookerMiddleware({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    if (user.isEmpty) {
      return AuthenticationPage();
    }

    return BlocBuilder<CookerBloc, CookerState>(
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        if (state.status == CookerStatus.loaded) {
          if (state.cooker.isEmpty) {
            return CreateUpdateCookerPage();
          }

          return BlocProvider(
            create: (_) =>
                PointsBloc(pointsRepository: context.read<PointsRepository>())
                  ..add(PointsOfCookerRequestedEvent(state.cooker.id)),
            child: child,
          );
        }

        return const SplashPage();
      },
    );
  }
}
