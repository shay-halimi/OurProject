import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/foods/foods.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:cookpoint/search/search.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class FoodsMap extends StatefulWidget {
  const FoodsMap({
    Key key,
  }) : super(key: key);

  @override
  _FoodsMapState createState() => _FoodsMapState();
}

class _FoodsMapState extends State<FoodsMap> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authenticated = context.select((AuthenticationBloc bloc) =>
        bloc.state.status == AuthenticationStatus.authenticated);

    final _appBars = <PreferredSizeWidget>[
      null,
      authenticated
          ? AppBar(
              title: Text(S.of(context).foodsPageTitle),
            )
          : null,
      authenticated
          ? AppBar(
              title: Text(S.of(context).accountPageTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Navigator.of(context)
                      .push<void>(RestaurantFormPage.route()),
                ),
              ],
            )
          : null,
    ];

    final _bodies = <Widget>[
      const MapViewBody(),
      authenticated ? const FoodsPageBody() : const LoginPageBody(),
      authenticated ? const RestaurantPageBody() : const LoginPageBody(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: _currentIndex != 0,
      appBar: _appBars[_currentIndex],
      body: _bodies[_currentIndex],
      endDrawer: const AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavigationBarItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: S.of(context).explore,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant),
            label: S.of(context).foodsPageTitle,
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
                return FoodsMapWidget(
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
                    (SearchBloc bloc) => bloc.state.selected.isNotEmpty),
                child: const FoodsBar(),
              ),
            ],
          ),
        )
      ],
    );
  }
}
