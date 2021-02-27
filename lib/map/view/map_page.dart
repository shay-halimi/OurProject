import 'package:cookpoint/app/app.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/map/map.dart';
import 'package:cookpoint/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: SearchAppBar(),
      drawer: AppDrawer(),
      body: MapWidget(),
      floatingActionButton: const _FloatingLocateButton(),
    );
  }
}

class _FloatingLocateButton extends StatelessWidget {
  const _FloatingLocateButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) async {
        if (state.status == LocationStateStatus.error) {
          await showDialog<void>(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text('אין גישה למיקום'),
                  content: Text('בדוק שיש הרשאות ושהשירות מופעל'),
                );
              }).then((_) => context.read<LocationCubit>().locate());
        }
      },
      child: FloatingActionButton(
        heroTag: '_FloatingLocateButton',
        tooltip: 'המיקום שלי',
        child: BlocBuilder<LocationCubit, LocationState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state.status == LocationStateStatus.located) {
              return const Icon(Icons.my_location);
            }

            return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
              theme.backgroundColor,
            ));
          },
        ),
        onPressed: context.read<LocationCubit>().locate,
      ),
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
