import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/media/media.dart';
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
      appBar: AppBar(title: const Text('התפריט שלי')),
      body: BlocBuilder<PointsBloc, PointsState>(
        buildWhen: (previous, current) =>
            previous.cookPoints != current.cookPoints,
        builder: (context, state) {
          if (state.cookPoints.isEmpty) {
            return const SplashBody(
              child: Text('נראה שעדיין לא פרסמת מאכלים.'),
            );
          }

          return ListView(
            children: [
              for (var point in state.cookPoints) ...[
                InkWell(
                  key: ValueKey(point.hashCode),
                  child: Card(
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: MediaWidget(
                            media: point.media.first,
                          ),
                        ),
                        ListTile(
                          isThreeLine: true,
                          title: Text(point.title),
                          subtitle: Text(
                            point.description,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => Navigator.of(context).push<void>(
                    PointPage.route(point: point),
                  ),
                ),
              ],
              ConstrainedBox(constraints: const BoxConstraints(minHeight: 64)),
            ],
          );
        },
      ),
      floatingActionButton: const CreatePointButton(),
    );
  }
}
