import 'package:flutter/material.dart';
import 'package:points_repository/points_repository.dart';

class AvailabilitySwitcher extends StatelessWidget {
  const AvailabilitySwitcher({
    Key key,
    this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    return Text(
      point.relevant
          ? 'אתה זמין, מספר הטלפון שלך מוצג ללקוחות והם יכולים להתקשר'
          : 'אתה לא זמין, לקוחות יכולים לשלוח הזמנות',
    );
  }
}
