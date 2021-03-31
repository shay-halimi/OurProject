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

    final box = ConstrainedBox(constraints: const BoxConstraints(minHeight: 8));

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: _PhotoURLInput()),
              box,
              ListTile(
                title: Text(cook.displayName),
                subtitle: const Text('שם לתצוגה'),
              ),
              box,
              ListTile(
                title: Text(cook.address.name),
                subtitle: const Text('כתובת'),
              ),
              box,
              ListTile(
                title: Text(cook.phoneNumber.toDisplay()),
                subtitle: const Text('מספר טלפון'),
              ),
            ],
          ),
        ),
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
