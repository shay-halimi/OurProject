import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class RestaurantMiddleware extends StatelessWidget {
  const RestaurantMiddleware({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final unauthenticated = context.select((AuthenticationBloc bloc) =>
        bloc.state.status == AuthenticationStatus.unauthenticated);

    if (unauthenticated) {
      return const AuthenticationPage();
    }

    return BlocBuilder<RestaurantBloc, RestaurantState>(
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        switch (state.status) {
          case RestaurantStatus.loaded:
            return child;

          case RestaurantStatus.error:
            return const RestaurantFormPage();

          default:
            return const SplashPage();
        }
      },
    );
  }
}
