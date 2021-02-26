import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/gallery/gallery_widget.dart';
import 'package:cookpoint/profile/profile.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:cookpoint/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    context.read<ProfileBloc>().add(ProfileRequestedEvent(user.id));

    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        switch (state.status) {
          case ProfileStateStatus.loading:
            return SplashPage();
            break;
          case ProfileStateStatus.loaded:
            return ProfileView();
            break;
          case ProfileStateStatus.empty:
            return CreateProfilePage();
            break;

          case ProfileStateStatus.error:
            return Text("error");
            break;

          default:
            return Text("unknown");
            break;
        }
      },
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("פרופיל"),
        actions: [
          GalleryWidget(
            icon: Icon(FontAwesomeIcons.camera),
            onDownloadUrl: context.read<ProfileBloc>().updatePhotoURL,
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return Text(state.status.toString());
          }),
    );
  }

  Column backup() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _PhotoURL(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    _DisplayName(),
                    _About(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () => null,
                icon: Icon(FontAwesomeIcons.whatsapp),
                label: Text("שלח הודעה"),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: () => null,
                icon: Icon(FontAwesomeIcons.phone),
                label: Text("התקשר"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DisplayName extends StatelessWidget {
  const _DisplayName({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state.status == ProfileStateStatus.loaded) {
          return Row(
            children: [
              Text(
                state.profile.displayName,
                style: theme.textTheme.headline6,
              ),
            ],
          );
        }
        return LinearProgressIndicator();
      },
    );
  }
}

class _PhotoURL extends StatelessWidget {
  const _PhotoURL({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state.status == ProfileStateStatus.loaded) {
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              state.profile.photoURL,
              fit: BoxFit.cover,
            ),
          );
        }
        return LinearProgressIndicator();
      },
    );
  }
}

class _About extends StatelessWidget {
  const _About({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state.status == ProfileStateStatus.loaded) {
          return Text(state.profile.about);
        }
        return LinearProgressIndicator();
      },
    );
  }
}
