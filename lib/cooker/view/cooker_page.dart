import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        isUpdating: false,
        cooker: cooker.copyWith(
          id: user.id,
          phoneNumber: user.phoneNumber,
        ),
      );
    }

    return CookerView(cooker: cooker);
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
        title: Text('החשבון שלי'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push<void>(
              CreateUpdateCookerPage.route(cooker: cooker, isUpdating: true),
            ),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(cooker.photoURL),
                  ),
                ],
              ),
              Divider(),
              Text('שם לתצוגה'),
              Text(
                cooker.displayName,
                style: theme.textTheme.headline4,
              ),
              Divider(),
              Text('כתובת'),
              Text(
                cooker.address.name,
                style: theme.textTheme.headline4,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
