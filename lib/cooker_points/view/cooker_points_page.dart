import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/cooker/bloc/bloc.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/cooker_points/cooker_points.dart';
import 'package:cookpoint/points/points.dart';
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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('המאכלים שלי')),
      body: BlocProvider(
        create: (_) => PointsBloc(
          pointsRepository: context.read<PointsRepository>(),
        )..add(PointsOfCookerRequestedEvent(cooker.id)),
        child: BlocBuilder<PointsBloc, PointsState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              if (state.status == PointStatus.loaded) {
                if (state.points.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('רשימת המאכלים שלך ריקה כרגע'),
                        ElevatedButton(
                          key: const Key(
                              'PointsOfCookerRequestedEventElevatedButton'),
                          child: const Text('הוסף מאכל'),
                          onPressed: () => Navigator.of(context)
                              .push<void>(CreatePointPage.route()),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    SwitchListTile(
                      title: const Text('על המפה'),
                      subtitle: const Text(
                          'משתמשים.ות אחרים.ות יוכלו לצפות בפרטי חשבונך, כגון: כתובת ומספר טלפון.'),
                      value: state.points
                          .where((point) => point.latLng.isNotEmpty)
                          .isNotEmpty,
                      onChanged: (value) => context
                          .read<PointsBloc>()
                          .changeLatLng(
                            state.points.toSet(),
                            value ? cooker.address.toLatLng() : LatLng.empty,
                          ),
                      isThreeLine: true,
                    ),
                    for (var point in state.points)
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(point.title),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => Navigator.of(context).push<void>(
                                CreateUpdatePointPage.route(
                                    point: point, isUpdating: true),
                              ),
                            ),
                          ],
                        ),
                        trailing: Switch(
                          value: point.latLng.isNotEmpty,
                          onChanged: (value) =>
                              context.read<PointsBloc>().changeLatLng(
                            {point},
                            value ? cooker.address.toLatLng() : LatLng.empty,
                          ),
                        ),
                      ),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .push<void>(CreatePointPage.route()),
                        child: Text('הוסף.י מאכל חדש')),
                  ],
                );
              }

              return const Center(child: CircularProgressIndicator());
            }),
      ),
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
