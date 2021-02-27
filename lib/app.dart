import 'package:accounts_repository/accounts_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/profile/profile.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:cookpoint/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location_repository/location_repository.dart';
import 'package:points_repository/points_repository.dart';

import 'home/home.dart';
import 'location/location.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.accountsRepository,
    @required this.locationRepository,
  })  : assert(authenticationRepository != null),
        assert(accountsRepository != null),
        assert(locationRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final AccountsRepository accountsRepository;
  final LocationRepository locationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: authenticationRepository,
        ),
        RepositoryProvider.value(
          value: accountsRepository,
        ),
        RepositoryProvider.value(
          value: locationRepository,
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
            create: (_) => ProfileBloc(
              accountsRepository: accountsRepository,
            ),
          ),
          BlocProvider(
            create: (_) => LocationCubit(
              locationRepository: locationRepository,
            ),
          ),
          BlocProvider(
            create: (_) => PointsCubit(
              pointsRepository: FirebasePointsRepository(),
            ),
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
                  HomePage.route(),
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
