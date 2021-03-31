import 'package:cookpoint/points/bloc/bloc.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SearchBloc(
            pointsBloc: context.read<PointsBloc>(),
          ),
        ),
        BlocProvider(
          create: (_context) => SelectedPointCubit(
            searchBloc: _context.read<SearchBloc>(),
          ),
        ),
      ],
      child: MapView(),
    );
  }
}
