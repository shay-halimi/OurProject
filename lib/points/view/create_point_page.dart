import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/points/view/create_point_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

class CreatePointPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreatePointPage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    if (user.isEmpty) {
      return AuthenticationPage();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('הוספת נקודת בישול')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => PointFormCubit(context.read<PointsRepository>())
            ..changeCookerId(user.id),
          child: const CreatePointForm(),
        ),
      ),
    );
  }
}
