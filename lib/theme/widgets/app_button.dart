import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key key,
    this.isInProgress = false,
    @required this.child,
    @required this.onPressed,
  }) : super(key: key);

  final bool isInProgress;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isInProgress) {
      return const CircularProgressIndicator();
    } else {
      return Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton(
                child: child,
                onPressed: onPressed,
              ),
            ),
          ),
        ],
      );
    }
  }
}
