import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/points/search/bloc/search_bloc.dart';
import 'package:cookpoint/points/widgets/points_bar.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location =
        context.select((LocationCubit cubit) => cubit.state.current);
    final points = context.select((SearchBloc bloc) => bloc.state.results);

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: MapAppBar(
        title: TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'מה בא לך לאכול?',
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) =>
              context.read<SearchBloc>().add(SearchTermUpdated(value)),
        ),
      ),
      body: Stack(
        children: [
          MapWidget(location: location, points: points),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PointsBar(points: points),
            ],
          ),
        ],
      ),
      endDrawer: AppDrawer(),
      floatingActionButton: const CreatePointButton(),
    );
  }
}
