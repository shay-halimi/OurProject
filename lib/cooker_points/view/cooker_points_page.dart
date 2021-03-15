import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/cooker/bloc/bloc.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/cooker_points/cooker_points.dart';
import 'package:cookpoint/media/media_widget.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

class CookerPointsPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CookerPointsPage());
  }

  @override
  Widget build(BuildContext context) {
    final cooker = context.select((CookerBloc bloc) => bloc.state.cooker);

    if (cooker.isEmpty) {
      return CookerPage();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              PointsBloc(pointsRepository: context.read<PointsRepository>())
                ..add(
                  PointsOfCookerRequestedEvent(
                    cooker.id,
                  ),
                ),
        ),
      ],
      child: CookerPointsPageView(cooker: cooker),
    );
  }
}

class CookerPointsPageView extends StatelessWidget {
  const CookerPointsPageView({
    Key key,
    @required this.cooker,
  }) : super(key: key);

  final Cooker cooker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('המטבח שלי')),
      body: BlocBuilder<PointsBloc, PointsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state.status == PointStatus.loaded) {
            if (state.points.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLogo(),
                    ConstrainedBox(constraints: BoxConstraints(minHeight: 64)),
                    const Text('רשימת המאכלים שלך ריקה כרגע'),
                  ],
                ),
              );
            }

            return _PointsWidget(
              points: state.points,
              cooker: cooker,
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: const CreatePointButton(),
    );
  }
}

class _PointsWidget extends StatelessWidget {
  const _PointsWidget({
    Key key,
    @required this.points,
    @required this.cooker,
  }) : super(key: key);

  final Iterable<Point> points;
  final Cooker cooker;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        for (var point in points) ...[
          Card(
            child: Column(
              children: [
                InkWell(
                  child: AspectRatio(
                    aspectRatio: 3 / 1,
                    child: Card(
                      child: MediaWidget(
                        media: point.media.first,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.of(context).push<void>(
                    CreateUpdatePointPage.route(point: point),
                  ),
                ),
                SwitchListTile(
                  title: Text("הצג על המפה"),
                  value: point.latLng.isNotEmpty,
                  onChanged: (value) => context.read<PointsBloc>().changeLatLng(
                    {point},
                    value ? cooker.address.toLatLng() : LatLng.empty,
                  ),
                ),
              ],
            ),
          ),
        ],
        ConstrainedBox(constraints: BoxConstraints(minHeight: 64)),
      ],
    );
  }
}

extension _XAddress on Address {
  LatLng toLatLng() {
    return LatLng(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
