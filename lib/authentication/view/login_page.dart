import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/authentication/login'),
      builder: (_) => const LoginPage(),
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).loginPageTitle)),
      resizeToAvoidBottomInset: true,
      body: const LoginPageBody(),
    );
  }
}

class LoginPageBody extends StatelessWidget {
  const LoginPageBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
      child: const LoginForm(),
    );
  }
}
