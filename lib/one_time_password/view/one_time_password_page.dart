import 'package:authentication_repository/authentication_repository.dart';
import 'package:cookpoint/one_time_password/one_time_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OneTimePasswordPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => OneTimePasswordPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('אמת מספר טלפון')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) =>
              OneTimePasswordCubit(context.read<AuthenticationRepository>()),
          child: OneTimePasswordForm(),
        ),
      ),
    );
  }
}
