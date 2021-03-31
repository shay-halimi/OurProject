import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: SearchAppBar(
        title: Row(
          children: [
            Expanded(
              child: _SearchField(),
            ),
            if (context.select(
                (PointsBloc bloc) => bloc.state.status == PointsStatus.loading))
              Container(
                child: const CircularProgressIndicator(),
                width: 16,
                height: 16,
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => showDialog<bool>(
                context: context,
                builder: (context) {
                  return Dialog(child: AppDrawer());
                }),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ],
      ),
      body: const _MapViewBody(),
      floatingActionButton: Visibility(
        visible: context
            .select((SelectedPointCubit cubit) => cubit.state.point.isEmpty),
        child: const CreatePointButton(),
      ),
    );
  }
}

class _MapViewBody extends StatelessWidget {
  const _MapViewBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.colorScheme.primary,
      child: BlocBuilder<LocationCubit, LocationState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (_, state) {
          switch (state.status) {
            case LocationStatus.unknown:
            case LocationStatus.loaded:
              return Stack(
                children: [
                  MapWidget(
                    pixelRatio: MediaQuery.of(context).devicePixelRatio,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PointsBar(),
                    ],
                  ),
                ],
              );
            case LocationStatus.error:
              return SplashBody(
                child: Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(32.0),
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'בכדי להמשיך יש להפעיל את שירותי המיקום במכשירך.',
                              style: theme.textTheme.headline6,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppButton(
                              child: const Text('נסה/י שוב'),
                              onPressed: context.read<LocationCubit>().locate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            default:
              return const SplashBody();
          }
        },
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  _SearchField({
    Key key,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.text,
      onChanged: (value) =>
          context.read<SearchBloc>().add(SearchTermUpdated(value)),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'מה בא לך לאכול?',
        suffixIcon:
            context.select((SearchBloc bloc) => bloc.state.term).isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context.read<SearchBloc>().add(const SearchTermCleared());
                      _controller.clear();
                      _hideKeyboard(context);
                    },
                  )
                : null,
      ),
    );
  }

  void _hideKeyboard(BuildContext context) => FocusScope.of(context).unfocus();
}
