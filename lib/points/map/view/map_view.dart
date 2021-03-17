import 'package:cookpoint/cooker_points/cooker_points.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/points/search/search.dart';
import 'package:cookpoint/points/widgets/points_bar.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapView extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: SearchAppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.text,
                onChanged: (value) =>
                    context.read<SearchBloc>().add(SearchTermUpdated(value)),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'מה בא לך לאכול?',
                  suffixIcon: context.select(
                          (SearchBloc bloc) => bloc.state.term.isNotEmpty)
                      ? IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            context
                                .read<SearchBloc>()
                                .add(SearchTermUpdated(''));
                            _controller.clear();
                            _hideKeyboard(context);
                          },
                        )
                      : null,
                ),
                controller: _controller,
              ),
            ),
            if (context.select(
                (PointsBloc bloc) => bloc.state.status == PointStatus.loading))
              Container(
                child: CircularProgressIndicator(),
                width: 16,
                height: 16,
              ),
          ],
        ),
      ),
      body: Stack(
        children: [
          MapWidget(
            points: context.select((SearchBloc bloc) => bloc.state.results),
            location:
                context.select((LocationCubit cubit) => cubit.state.current),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PointsBar(
                points: context.select((SearchBloc bloc) => bloc.state.results),
              ),
            ],
          ),
        ],
      ),
      endDrawer: AppDrawer(),
      floatingActionButton: BlocBuilder<SelectedPointCubit, SelectedPointState>(
        buildWhen: (previous, current) => previous != current,
        builder: (_, state) {
          return Visibility(
            visible: state.point.isEmpty,
            child: const CreatePointButton(),
          );
        },
      ),
    );
  }

  void _hideKeyboard(BuildContext context) => FocusScope.of(context).unfocus();
}
