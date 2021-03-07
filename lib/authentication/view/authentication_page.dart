import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => AuthenticationPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          switch (state.status) {
            case AuthenticationStatus.authenticated:
              return ProfilePage();
              break;
            case AuthenticationStatus.unauthenticated:
              return PhoneNumberPage();
              break;
            default:
              return const SplashPage();
              break;
          }
        });
  }
}
