import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'ColorUtils.dart';


class CommonStyles {
  static textFormFieldStyle(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
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

  static textFieldsPadding()
  {
    return const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10);
  }

  static searchFieldStyle(String label, String hint) {
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

static void showLoadingDialog(BuildContext context)
{
  showDialog(
      builder: (context) => Center(
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
      context: context
  );

 }

  static Widget loadingBar(BuildContext context)
  {
    return Container(
      margin: EdgeInsets.all(20),
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey,
        color: ColorUtils.primaryColor,
        strokeWidth: 5,
      ),
    );
  }


}