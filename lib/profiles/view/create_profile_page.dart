import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/profiles/profiles.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profiles_repository/profiles_repository.dart';

class CreateProfilePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreateProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    final profile = Profile.empty.copyWith(
      id: user.id,
      displayName: user.displayName,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
    );

    context.read<ProfilesBloc>().add(ProfileCreatedEvent(profile));

    return const SplashPage();
  }
}
