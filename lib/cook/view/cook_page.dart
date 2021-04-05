import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/media/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CookPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => CookMiddleware(child: CookPage()));
  }

  @override
  Widget build(BuildContext context) {
    final cook = context.select((CookBloc bloc) => bloc.state.cook);

    return Scaffold(
      appBar: AppBar(
        title: const Text('המטבח שלי'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                Navigator.of(context).push<void>(CreateUpdateCookPage.route()),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: _PhotoURLInput()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(32.0),
              children: [
                ListTile(
                  title: Text(cook.displayName),
                  subtitle: const Text('שם לתצוגה'),
                ),
                ListTile(
                  title: Text(cook.address.name),
                  subtitle: const Text('כתובת'),
                ),
                ListTile(
                  title: Text(cook.phoneNumber.toDisplay()),
                  subtitle: const Text('מספר טלפון'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoURLInput extends StatelessWidget {
  const _PhotoURLInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CookBloc, CookState>(
      buildWhen: (previous, current) =>
          previous.cook.photoURL != current.cook.photoURL,
      builder: (_, state) {
        return PhotoURLWidget(
          photoURL: state.cook.photoURL,
          onPhotoURLChanged: (value) {
            context.read<CookBloc>().add(CookUpdatedEvent(state.cook.copyWith(
                  photoURL: value,
                )));
          },
        );
      },
    );
  }
}

extension _XPhoneNumber on String {
  String toDisplay() {
    try {
      return '0${substring(4, 6)}-${substring(6, 9)}-${substring(9)}';
    } on Error {
      return toString();
    }
  }
}
