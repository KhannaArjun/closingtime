import 'package:flutter/material.dart';

class CircularProgressIndicatorApp extends StatelessWidget {
  const CircularProgressIndicatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator
      (
      backgroundColor: Colors.black,
      strokeWidth: 8,
    );
  }
}