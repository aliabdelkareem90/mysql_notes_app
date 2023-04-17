import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomIconButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final void Function()? onPressed;

  const CustomIconButton({
    Key? key,
    required this.text,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 50.0),
          Text(text, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}
