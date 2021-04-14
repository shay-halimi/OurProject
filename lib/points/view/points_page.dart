import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PointsPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => CookMiddleware(child: PointsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('המטבח שלי'),
      ),
      body: BlocBuilder<PointsBloc, PointsState>(
        buildWhen: (previous, current) =>
            previous.cookPoints != current.cookPoints,
        builder: (_, state) {
          if (state.cookPoints.isEmpty) {
            return SplashBody(
              child: Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'נראה שעדיין לא פרסמת מאכלים.',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return HeroMode(
            enabled: false,
            child: ListView(
              children: [
                for (var point in state.cookPoints)
                  PointWidget(
                    point: point,
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: const CreatePointButton(),
    );
  }
}
