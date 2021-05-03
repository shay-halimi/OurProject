import 'package:cookpoint/foods/foods.dart';
import 'package:cookpoint/legal/legal.dart';
import 'package:cookpoint/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/'),
      builder: (_) => TermsOfServiceMiddleware(child: const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SearchBloc(
            foodsBloc: context.read<FoodsBloc>(),
          ),
        ),
      ],
      child: const FoodsMap(),
    );
  }
}
