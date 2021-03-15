import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/cooker_points/cooker_points.dart';
import 'package:cookpoint/points/points.dart';
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
      child: BlocListener<PointsBloc, PointsState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state.status == PointStatus.loaded && state.points.length >= 3) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                    content: Text(
                  'אין אפשרות להוסיף יותר משלושה מאכלים כרגע',
                )),
              );
            Navigator.of(context).pop();
          }
        },
        child: CreateUpdatePointPage(point: Point.empty),
      ),
    );
  }
}
