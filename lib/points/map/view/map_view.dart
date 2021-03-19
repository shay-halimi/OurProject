import 'package:cookpoint/cooker_points/cooker_points.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
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
                            context.read<SearchBloc>().add(SearchTermCleared());
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
          MapWidget(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PointsBar(),
            ],
          ),
        ],
      ),
      endDrawer: AppDrawer(),
      floatingActionButton: Visibility(
        visible: context
            .select((SelectedPointCubit cubit) => cubit.state.point.isEmpty),
        child: const CreatePointButton(),
      ),
    );
  }

  void _hideKeyboard(BuildContext context) => FocusScope.of(context).unfocus();
}
