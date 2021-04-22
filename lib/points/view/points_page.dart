import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PointsPage extends StatelessWidget {
  const PointsPage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/points'),
      builder: (_) => const CookMiddleware(child: PointsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).pointsPageTitle),
      ),
      body: const PointsPageBody(),
      floatingActionButton: const CreatePointButton(),
    );
  }
}

class PointsPageBody extends StatelessWidget {
  const PointsPageBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointsBloc, PointsState>(
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
                      S
                          .of(context)
                          .looks_like_you_haven_t_posted_any_points_yet,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          children: [
            for (var point in state.cookPoints)
              PointWidget(
                point: point,
              ),
          ],
        );
      },
    );
  }
}
