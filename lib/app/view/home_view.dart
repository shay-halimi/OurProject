import 'package:cookpoint/app/app.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/places/places.dart';
import 'package:cookpoint/points/bloc/bloc.dart';
import 'package:cookpoint/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    final point = context.select(
      (PointsBloc bloc) => bloc.state.points.firstWhere(
        (point) => point.id == user.id,
        orElse: () => Point.empty.copyWith(id: user.id),
      ),
    );

    return BlocListener<PlacesCubit, PlacesState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) async {
        switch (state.status) {
          case PlacesStateStatus.located:
            final event = PointUpdatedEvent(
              point.copyWith(
                location: Location(
                  latitude: state.place.latitude,
                  longitude: state.place.longitude,
                ),
              ),
            );

            context.read<PointsBloc>().add(event);

            break;

          case PlacesStateStatus.error:
            await showDialog<void>(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    title: Text('אין גישה למיקום'),
                    content: Text('בדוק שיש הרשאות ושהשירות מופעל'),
                  );
                });

            break;

          case PlacesStateStatus.unknown:
            break;

          case PlacesStateStatus.locating:
            break;
        }
      },
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        appBar: SearchAppBar(),
        drawer: AppDrawer(),
        body: MapWidget(),
        floatingActionButton: _FloatingButtons(
          point: point,
        ),
      ),
    );
  }
}

class _FloatingButtons extends StatelessWidget {
  const _FloatingButtons({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          heroTag: '_FloatingLocateButton',
          tooltip: 'המיקום שלי',
          child: BlocBuilder<PlacesCubit, PlacesState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              if (state.status == PlacesStateStatus.located) {
                return const Icon(Icons.my_location);
              }

              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.backgroundColor,
                ),
              );
            },
          ),
          onPressed: context.read<PlacesCubit>().locate,
        ),
        FloatingActionButton(
          heroTag: '_FloatingLocateButton',
          tooltip: 'המיקום שלי',
          child: BlocBuilder<PlacesCubit, PlacesState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              if (point.available) {
                return const Icon(Icons.brightness_high);
              }

              return const Icon(Icons.brightness_low);
            },
          ),
          onPressed: () =>
              context.read<PointsBloc>().add(PointUpdatedEvent(point.copyWith(
                    available: !point.available,
                  ))),
        ),
      ],
    );
  }
}

class ProductsWidget extends StatelessWidget {
  const ProductsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SearchAppBar extends AppBar {
  /// todo https://github.com/ArcticZeroo/flutter-search-bar

  SearchAppBar({
    Key key,
  }) : super(
          key: key,
          title: AppTitle(),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => null,
            ),
          ],
        );
}
