import 'package:cookpoint/profile/profile.dart';
import 'package:cookpoint/gallery/gallery_widget.dart';
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
        title: Text("פרופיל"),
        actions: [
          GalleryWidget(
            icon: Icon(FontAwesomeIcons.camera),
            onDownloadUrl: (url) =>
                context.read<ProfileBloc>().updatePhotoUrl(url),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PhotoUrl(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
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

class _PhotoUrl extends StatelessWidget {
  const _PhotoUrl({
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
              state.profile.photoUrl,
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
