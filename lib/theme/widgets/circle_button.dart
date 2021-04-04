import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    Key key,
    this.onPressed,
    this.child,
    this.fillColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 2.0,
      fillColor: fillColor ?? Colors.white.withOpacity(0.9),
      child: child,
      padding: const EdgeInsets.all(8.0),
      shape: const CircleBorder(),
      constraints: const BoxConstraints(minHeight: 32.0),
    );
  }
}
