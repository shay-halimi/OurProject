import 'package:cookpoint/imagez.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:flutter/material.dart';

export 'cubit/cubit.dart';

class RestaurantWidget extends StatelessWidget {
  const RestaurantWidget({
    Key key,
    @required this.restaurant,
  }) : super(key: key);

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage:
                restaurant.isEmpty ? null : imagez.url(restaurant.photoURL),
          ),
          title: Text(restaurant.displayName),
        ),
        if (restaurant.isEmpty) const LinearProgressIndicator(),
      ],
    );
  }
}
