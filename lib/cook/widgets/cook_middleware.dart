import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CookMiddleware extends StatelessWidget {
  const CookMiddleware({
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

    return BlocBuilder<CookBloc, CookState>(
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        switch (state.status) {
          case CookStatus.loaded:
            return child;

          case CookStatus.error:
            return const CreateUpdateCookPage();

          default:
            return const SplashPage();
        }
      },
    );
  }
}
