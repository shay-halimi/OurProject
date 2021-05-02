import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/points/points.dart';
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
        return ListView(
          children: [
            Card(
              child: ListTile(
                onTap: () => Navigator.of(context)
                    .push<void>(PointFormPage.route(point: Point.empty)),
                leading: const Icon(Icons.add),
                title: Text(S.of(context).createPointBtn),
              ),
            ),
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
