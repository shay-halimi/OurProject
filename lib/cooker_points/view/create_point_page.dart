import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/cooker_points/cooker_points.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

class CreatePointPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreatePointPage());
  }

  @override
  Widget build(BuildContext context) {
    final cooker = context.select((CookerBloc bloc) => bloc.state.cooker);

    if (cooker.isEmpty) {
      return CookerPage();
    }

    return BlocProvider(
      create: (_) =>
          PointsBloc(pointsRepository: context.read<PointsRepository>())
            ..add(
              PointsOfCookerRequestedEvent(
                cooker.id,
              ),
            ),
      child: BlocBuilder<PointsBloc, PointsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state.status == PointStatus.loaded) {
            if (state.points.length >= 3) {
              return Scaffold(
                body: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: AppLogo(),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'אין אפשרות להוסיף יותר משלושה מאכלים כרגע',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('סגור'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return const CreateUpdatePointPage(point: Point.empty);
          }

          return const SplashPage();
        },
      ),
    );
  }
}
