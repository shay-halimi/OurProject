import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

class MyPointsPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MyPointsPage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    if (user.isEmpty) {
      return AuthenticationPage();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('הנקודות בישול שלי')),
      body: BlocProvider(
        create: (_) => PointsBloc(
          pointsRepository: context.read<PointsRepository>(),
        )..add(PointsOfCookerRequestedEvent(user.id)),
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
                          onPressed: () => Navigator.of(context).push<void>(
                            CreatePointPage.route(),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                    child: Column(
                  children: [
                    for (var point in state.points)
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: PointWidget(point: point),
                      ),
                  ],
                ));
              }

              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
