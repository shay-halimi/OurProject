import 'package:cookpoint/app/view/home_view.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/profiles/profiles.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    context.read<ProfilesBloc>()..add(ProfileSubscribedEvent(user.id));
    context.read<PointsBloc>()..add(PointSubscribedEvent(user.id));

    return BlocBuilder<ProfilesBloc, ProfilesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        switch (state.status) {
          case ProfileStateStatus.loading:
            return SplashPage();
            break;
          case ProfileStateStatus.loaded:
            return HomeView();
            break;
          case ProfileStateStatus.empty:
            return CreateProfilePage();
            break;
          default:
            return const Text('unknown');
            break;
        }
      },
    );
  }
}
