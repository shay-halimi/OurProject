import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/location/location.dart';
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
    final location =
        context.select((LocationCubit cubit) => cubit.state.current);

    if (location.isEmpty) {
      return LocationPage();
    }

    final cooker = context.select((CookerBloc bloc) => bloc.state.cooker);

    if (cooker.isEmpty) {
      return CookerPage();
    }

    return CreateUpdatePointPage(
      point: Point.empty.copyWith(
        cookerId: cooker.id,
        latitude: location.latitude,
        longitude: location.longitude,
      ),
    );
  }
}
