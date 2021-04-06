import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/home_page.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
            lazy: false,
          ),
          BlocProvider(
            create: (_context) => CookBloc(
              cooksRepository: cooksRepository,
              authenticationBloc: _context.read<AuthenticationBloc>(),
            ),
            lazy: false,
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cook Point',
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
      onGenerateRoute: (_) => SplashPage.route(),
      home: HomePage(),
    );
  }
}
