import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

class CookerPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CookerPage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    if (user.isEmpty) {
      return AuthenticationPage();
    }

    final cooker = context.select((CookerBloc bloc) => bloc.state.cooker);

    if (cooker.isEmpty) {
      return CreateUpdateCookerPage(
        cooker: cooker,
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              PointsBloc(pointsRepository: context.read<PointsRepository>())
                ..add(
                  PointsOfCookerRequestedEvent(cooker.id),
                ),
        ),
      ],
      child: CookerView(cooker: cooker),
    );
  }
}

class CookerView extends StatelessWidget {
  const CookerView({
    Key key,
    @required this.cooker,
  }) : super(key: key);

  final Cooker cooker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('המטבח שלי'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _PhotoURLInput()),
              ConstrainedBox(constraints: BoxConstraints(minHeight: 8)),
              ListTile(
                title: Text(cooker.displayName),
                subtitle: Text('שם לתצוגה'),
                onTap: () => Navigator.of(context).push<void>(
                  CreateUpdateCookerPage.route(
                    cooker: cooker,
                  ),
                ),
                trailing: Icon(Icons.edit),
              ),
              ConstrainedBox(constraints: BoxConstraints(minHeight: 8)),
              ListTile(
                title: Text(cooker.address.name),
                subtitle: Text('כתובת'),
                onTap: () => Navigator.of(context).push<void>(
                  CreateUpdateCookerPage.route(
                    cooker: cooker,
                  ),
                ),
                trailing: Icon(Icons.edit),
              ),
              ConstrainedBox(constraints: BoxConstraints(minHeight: 8)),
              ListTile(
                title: Text(cooker.phoneNumber.toDisplay()),
                subtitle: Text('מספר טלפון'),
              ),
              ConstrainedBox(constraints: BoxConstraints(minHeight: 8)),
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
    return "0" + substring(4, 6) + "-" + substring(6, 9) + "-" + substring(9);
  }
}
