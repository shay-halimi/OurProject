import 'package:authentication_repository/authentication_repository.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/map/map.dart';
import 'package:cookpoint/orders/orders.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/products/products.dart';
import 'package:cookpoint/profiles/profiles.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location_services/location_services.dart';
import 'package:points_repository/points_repository.dart';
import 'package:profiles_repository/profiles_repository.dart';

import 'file:///C:/Users/Matan/StudioProjects/flutter_app/lib/theme/theme.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.profilesRepository,
    @required this.pointsRepository,
    @required this.locationServices,
  })  : assert(authenticationRepository != null),
        assert(profilesRepository != null),
        assert(pointsRepository != null),
        assert(locationServices != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final ProfilesRepository profilesRepository;
  final PointsRepository pointsRepository;
  final LocationServices locationServices;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: authenticationRepository,
        ),
        RepositoryProvider.value(
          value: profilesRepository,
        ),
        RepositoryProvider.value(
          value: pointsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (_) => ProfilesBloc(
              profilesRepository: profilesRepository,
            ),
          ),
          BlocProvider(
            create: (_) => PointsBloc(
              pointsRepository: pointsRepository,
            ),
          ),
          BlocProvider(
            create: (context) => LocationCubit(
              locationServices: locationServices,
            ),
          ),
          BlocProvider(
            create: (_) => ProductCubit(),
          ),
          BlocProvider(
            create: (_) => OrderCubit(),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('he', 'IL'),
      ],
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  MapPage.route(),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  AuthenticationPage.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
