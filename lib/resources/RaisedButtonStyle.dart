import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressedd;

  const SubmitButton({Key? key, required this.title, required this.onPressedd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        buttonTheme: const ButtonThemeData(

          textTheme: ButtonTextTheme.normal,
        ),
      ),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.red),
        ),
        color: Colors.red,
        // color: Colors.transparent,
        // disabledColor: Colors.grey
        textColor: Colors.white,
        onPressed: onPressedd,
        child: Text(title),
      ),
    );
  }
}