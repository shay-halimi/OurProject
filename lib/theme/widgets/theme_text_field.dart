import 'package:flutter/material.dart';

class ThemeTextField extends StatelessWidget {
  const ThemeTextField({
    Key key,
    this.onTap,
    this.onChanged,
    this.controller,
    this.autoFocus = false,
    this.suffixIcon,
    this.prefixIcon,
    this.placeholder,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final bool autoFocus;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      onChanged: onChanged,
      controller: controller,
      autofocus: autoFocus,
      decoration: InputDecoration(
        filled: true,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(width: 1.0, style: BorderStyle.solid),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(width: 1.0, style: BorderStyle.solid),
        ),
        hintText: placeholder,
      ),
    );
  }
}
