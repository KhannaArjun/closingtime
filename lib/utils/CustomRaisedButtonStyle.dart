import 'package:flutter/material.dart';

import 'ColorUtils.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const CustomRaisedButton({
    Key key = const Key("any_key"),
    required this.child,
    this.width = double.infinity,
    this.height = 40.0,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(40.0)),
          gradient: ColorUtils.volunteerAccentGradient,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.4),
              offset: const Offset(0.0, 2.0),
              blurRadius: 4.0,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(40.0)),
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}