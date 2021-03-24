import 'package:cookpoint/cooker_points/cooker_points.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:cookpoint/theme/theme.dart';
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
                (PointsBloc bloc) => bloc.state.status == PointStatus.loading))
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
      body: Stack(
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
      ),
      floatingActionButton: Visibility(
        visible: context
            .select((SelectedPointCubit cubit) => cubit.state.point.isEmpty),
        child: const CreatePointButton(),
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
