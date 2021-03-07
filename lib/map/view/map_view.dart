import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/map/map.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/points/widgets/points_bar.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    final points = context.select((PointsBloc bloc) => bloc.state.points);

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          MapWidget(
            points: points,
          ),
          const LocateButton(),
        ],
      ),
      appBar: MapAppBar(
        title: const TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'מה בא לך לאכול?',
          ),
          keyboardType: TextInputType.text,
        ),
      ),
      endDrawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'FloatingActionButtonCookPoint',
        tooltip: 'פרסם CookPoint',
        child: const Icon(Icons.add_location),
        onPressed: () {
          if (user.isEmpty) {
            Navigator.of(context).push<void>(AuthenticationPage.route());
          } else {
            Navigator.of(context).push<void>(CreatePointPage.route());
          }
        },
      ),
      bottomSheet: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: PointsBar(
          points: points,
        ),
      ),
    );
  }
}
