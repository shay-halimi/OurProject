import 'package:authentication_repository/authentication_repository.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneNumberPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => PhoneNumberPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('התחבר')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => PhoneNumberCubit(
            context.read<AuthenticationRepository>(),
          ),
          child: PhoneNumberForm(),
        ),
      ),
    );
  }
}
