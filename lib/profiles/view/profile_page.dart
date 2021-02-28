import 'package:cookpoint/profiles/profiles.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('פרופיל'),
        actions: [
          const ChangePhotoURLWidget(),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _PhotoURL(),
          SingleChildScrollView(
            child: Column(
              children: [
                const _DisplayName(),
                const _About(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () => null,
                  icon: const Icon(FontAwesomeIcons.whatsapp),
                  label: const Text('שלח הודעה'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () => null,
                  icon: const Icon(FontAwesomeIcons.phone),
                  label: const Text('התקשר'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DisplayName extends StatelessWidget {
  const _DisplayName({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesBloc, ProfilesState>(
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
        return const LinearProgressIndicator();
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
    return BlocBuilder<ProfilesBloc, ProfilesState>(
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
        return const LinearProgressIndicator();
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
    return BlocBuilder<ProfilesBloc, ProfilesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state.status == ProfileStateStatus.loaded) {
          return Text(state.profile.about);
        }
        return const LinearProgressIndicator();
      },
    );
  }
}
