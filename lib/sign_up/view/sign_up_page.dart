import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cookpoint/sign_up/sign_up.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(context.read<AuthenticationRepository>()),
          child: Column(
            children: [
              SignUpForm(),
              _TermsOfServiceBtn(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsOfServiceBtn extends StatelessWidget {
  const _TermsOfServiceBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        "by_clicking_let_s_start_you_accepting_our_terms_of_service",
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(fontSize: 10),
      ),
      onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("terms_of_service"),
                content: SingleChildScrollView(child: Text("terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_oterms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body f_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body ")),
                actions: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pop(),
                    child: Text("terms_of_service_ok"),
                  ),
                ]);
          }),
    );
  }
}
