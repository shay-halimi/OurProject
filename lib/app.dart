import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/home_page.dart';
import 'package:cookpoint/internet/internet.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.pointsRepository,
    @required this.locationServices,
    @required this.cooksRepository,
  })  : assert(authenticationRepository != null),
        assert(pointsRepository != null),
        assert(locationServices != null),
        assert(cooksRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;

  final PointsRepository pointsRepository;

  final LocationServices locationServices;

  final CooksRepository cooksRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: authenticationRepository,
        ),
        RepositoryProvider.value(
          value: pointsRepository,
        ),
        RepositoryProvider.value(
          value: locationServices,
        ),
        RepositoryProvider.value(
          value: cooksRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => InternetCubit()..check(),
          ),
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (_context) => CookBloc(
              cooksRepository: cooksRepository,
              authenticationBloc: _context.read<AuthenticationBloc>(),
            ),
          ),
          BlocProvider(
            create: (_context) => PointsBloc(
              pointsRepository: pointsRepository,
              cookBloc: _context.read<CookBloc>(),
            ),
          ),
          BlocProvider(
            create: (_context) => LocationCubit(
              locationServices: locationServices,
              cookBloc: _context.read<CookBloc>(),
            )..locate(),
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
      title: 'CookPoint',
      theme: theme,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('he', 'IL'),
      ],
      navigatorKey: _navigatorKey,
      builder: (_, child) {
        return BlocListener<InternetCubit, InternetState>(
          listener: (_, state) {
            switch (state.status) {
              case InternetStatus.loaded:
                _navigator.pushAndRemoveUntil<void>(
                    HomePage.route(), (_) => false);
                break;
              case InternetStatus.error:
                _navigator.pushAndRemoveUntil<void>(
                    ErrorPage.route(), (_) => false);
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
