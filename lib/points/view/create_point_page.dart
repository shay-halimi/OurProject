import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';

class CreatePointPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => CookMiddleware(child: CreatePointPage()));
  }

  @override
  Widget build(BuildContext context) {
    final canCreatePoint =
        context.select((PointsBloc bloc) => bloc.state.cookPoints.length < 3);

    if (canCreatePoint) {
      return const CreateUpdatePointPage(point: Point.empty);
    }

    return const _TooManyPointsPage();
  }
}

class _TooManyPointsPage extends StatelessWidget {
  const _TooManyPointsPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppCover(),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'אין אפשרות להוסיף יותר משלושה מאכלים כרגע',
                    style: theme.textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.close),
        label: const Text('סגור'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
