import 'package:accounts_repository/accounts_repository.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/profile/profile.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProfilePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreateProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    final profile = Account.empty.copyWith(
      id: user.id,
      displayName: user.displayName,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
    );

    context.read<ProfileBloc>().add(ProfileCreatedEvent(profile));

    return SplashPage();
  }
}
