import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/cooker_points/cooker_points.dart';
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

    return CreateUpdatePointPage(
      point: Point.empty.copyWith(
        cookerId: cooker.id,
        latLng: LatLng(
          latitude: cooker.address.latitude,
          longitude: cooker.address.longitude,
        ),
      ),
      isUpdating: false,
    );
  }
}
