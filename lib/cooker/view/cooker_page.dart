import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/cooker_points/cooker_points.dart';
import 'package:cookpoint/media/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CookerPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => CookerMiddleware(child: CookerPage()));
  }

  @override
  Widget build(BuildContext context) {
    final cooker = context.select((CookerBloc bloc) => bloc.state.cooker);

    final box = ConstrainedBox(constraints: const BoxConstraints(minHeight: 8));

    return Scaffold(
      appBar: AppBar(
        title: const Text('המטבח שלי'),
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
                title: Text(cooker.displayName),
                subtitle: const Text('שם לתצוגה'),
                onTap: () => Navigator.of(context)
                    .push<void>(CreateUpdateCookerPage.route()),
                trailing: const Icon(Icons.edit),
              ),
              box,
              ListTile(
                title: Text(cooker.address.name),
                subtitle: const Text('כתובת'),
                onTap: () => Navigator.of(context)
                    .push<void>(CreateUpdateCookerPage.route()),
                trailing: const Icon(Icons.edit),
              ),
              box,
              ListTile(
                title: Text(cooker.phoneNumber.toDisplay()),
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
    return BlocBuilder<CookerBloc, CookerState>(
      buildWhen: (previous, current) =>
          previous.cooker.photoURL != current.cooker.photoURL,
      builder: (_, state) {
        return PhotoURLWidget(
          photoURL: state.cooker.photoURL,
          onPhotoURLChanged: (value) {
            context
                .read<CookerBloc>()
                .add(CookerUpdatedEvent(state.cooker.copyWith(
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
    return '0${substring(4, 6)}-${substring(6, 9)}-${substring(9)}';
  }
}
