import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/cook/view/cook_page.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:cookpoint/selected_point/selected_point.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  const MapView({
    Key key,
  }) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authenticated = context.select((AuthenticationBloc bloc) =>
        bloc.state.status == AuthenticationStatus.authenticated);

    final authAppBar = AppBar(title: Text(S.of(context).loginPageTitle));

    final _appBars = <PreferredSizeWidget>[
      null,
      authenticated
          ? AppBar(
              title: Text(S.of(context).pointsPageTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => Navigator.of(context)
                      .push<void>(PointPage.route(point: Point.empty)),
                ),
              ],
            )
          : authAppBar,
      authenticated
          ? AppBar(
              title: Text(S.of(context).accountPageTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Navigator.of(context)
                      .push<void>(CreateUpdateCookPage.route()),
                ),
              ],
            )
          : authAppBar,
    ];

    final _bodies = <Widget>[
      const MapViewBody(),
      authenticated ? const PointsPageBody() : const LoginPageBody(),
      authenticated ? const CookPageBody() : const LoginPageBody(),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: _appBars[_currentIndex],
      body: _bodies[_currentIndex],
      endDrawer: const AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onBottomNavigationBarItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: S.of(context).explore,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu),
            label: S.of(context).pointsPageTitle,
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              child: const Icon(Icons.account_circle),
              onLongPress: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequestedEvent()),
            ),
            label: S.of(context).accountPageTitle,
          ),
        ],
      ),
    );
  }

  void _onBottomNavigationBarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class MapViewBody extends StatelessWidget {
  const MapViewBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<LocationCubit, LocationState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (_, state) {
            switch (state.status) {
              case LocationStatus.unknown:
              case LocationStatus.loading:
                return const SplashBody();
              default:
                return MapWidget(
                  pixelRatio: MediaQuery.of(context).devicePixelRatio,
                );
            }
          },
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SearchAppBar(),
              Visibility(
                visible: context.select(
                    (SelectedPointCubit cubit) => cubit.state.point.isNotEmpty),
                child: const PointsBar(),
              ),
            ],
          ),
        )
      ],
    );
  }
}
