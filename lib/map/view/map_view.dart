import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/map/map.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: AppTitle(),
        centerTitle: true,
        actions: [
          BlocBuilder<LocationCubit, LocationState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: IconButton(
                  icon: const Icon(Icons.explore),
                  onPressed: () =>
                      context.read<MapCubit>().updateLocation(state.current),
                ),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SlidingSheet(
        body: MapWidget(),
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snappings: [1 / 3, 3 / 4, 1 / 1],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height * 3 / 4,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  'https://loremflickr.com/640/480?random=$index',
                );
              },
              itemCount: 10,
              pagination: const SwiperPagination(),
              control: const SwiperControl(),
            ),
          );
        },
      ),
    );
  }
}
