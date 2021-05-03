import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/foods/foods.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/home_page.dart';
import 'package:cookpoint/internet/internet.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:cookpoint/settings/cubit/cubit.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.foodsRepository,
    @required this.locationServices,
    @required this.restaurantsRepository,
  })  : assert(authenticationRepository != null),
        assert(foodsRepository != null),
        assert(locationServices != null),
        assert(restaurantsRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;

  final FoodsRepository foodsRepository;

  final LocationServices locationServices;

  final RestaurantsRepository restaurantsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: authenticationRepository,
        ),
        RepositoryProvider.value(
          value: foodsRepository,
        ),
        RepositoryProvider.value(
          value: locationServices,
        ),
        RepositoryProvider.value(
          value: restaurantsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => InternetCubit()..check(),
          ),
          BlocProvider(
            create: (_) => SettingsCubit(),
          ),
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (_context) => RestaurantBloc(
              restaurantsRepository: restaurantsRepository,
              authenticationBloc: _context.read<AuthenticationBloc>(),
            ),
          ),
          BlocProvider(
            create: (_context) => FoodsBloc(
              foodsRepository: foodsRepository,
              restaurantBloc: _context.read<RestaurantBloc>(),
            ),
          ),
          BlocProvider(
            create: (_) => LocationCubit(
              locationServices: locationServices,
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
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) => previous.locale != current.locale,
      builder: (_, settings) {
        return MaterialApp(
          title: 'CookPoint',
          theme: theme,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
          ],
          localizationsDelegates: [
            S.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('he', 'IL'),
          ],
          locale: settings.locale.toLocale(),
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
      },
    );
  }
}

extension _XSettingsLocale on SettingsLocale {
  /// @nullable
  Locale toLocale() {
    switch (this) {
      case SettingsLocale.hebrew:
        return const Locale('he', 'IL');

      case SettingsLocale.english:
        return const Locale('en', 'US');

      default:
        return null;
    }
  }
}
