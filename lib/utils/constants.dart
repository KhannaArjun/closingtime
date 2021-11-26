import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constants
{
  static const String BASE_URL = "http://127.0.0.1:5000";
  //static const String BASE_URL = "https://closingtime.herokuapp.com";
  static const Map<String, String> HEADERS = {'Content-Type': 'application/json'};

  static const String empty = "No data";
  static const String user_exists = "User already exists";
  static const String user_id = "user_id";

  static void showToast(msg)
  {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
    );
  }
}