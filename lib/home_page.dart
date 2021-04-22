import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'selected_point/selected_point.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/'),
      builder: (_) => const HomePage(),
    );
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
      child: const MapView(),
    );
  }
}
