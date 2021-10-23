import 'package:flutter/material.dart';

class CommonStyles {
  static textFormFieldStyle(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint:true,
      contentPadding: EdgeInsets.symmetric(vertical: 5),
      labelStyle: TextStyle(color: Colors.black),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black,
            width: 2
        ),
      ),
    );
  }

  static layoutBackgroundShape()
  {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular( 20),
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0)),
      child: Container(
        color: Colors.blue,

      ),
    );
  }
}