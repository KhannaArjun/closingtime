import 'dart:typed_data';

import 'package:closingtime/utils/ColorUtils.dart';
import 'package:flutter/material.dart';

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestHomePage(),
    );
  }
}

class TestHomePage extends StatefulWidget {
  @override
  _TestHomePage createState() => _TestHomePage();
}

class _TestHomePage extends State<TestHomePage> {

  @override
  void initState() {
    // googlePlace = GooglePlace("AIzaSyC6BSkN2od9soYaSaiIou-Ctcop186rWPg");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("appTitle")),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Text(
                'Name',
                style: TextStyle(
                  color: ColorUtils.primaryColor,
                  fontSize: 14,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500
                ),
              ),),),

          Align (
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w300,
                fontSize: 14
              ),
              onFieldSubmitted: (_) {
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter food item name";
                }
                return null;
              },
              decoration: _textFormFieldStyle("", "Food Name"),
            ),
          ),),

              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    'Name',
                    style: TextStyle(
                        color: ColorUtils.primaryColor,
                        fontSize: 14,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500
                    ),
                  ),),),

              Align (
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                    ),
                    onFieldSubmitted: (_) {
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter food item name";
                      }
                      return null;
                    },
                    decoration: _textFormFieldStyle("", "Food Name"),
                  ),
                ),),

              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    'Name',
                    style: TextStyle(
                        color: ColorUtils.primaryColor,
                        fontSize: 14,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w400
                    ),
                  ),),),

              Align (
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      fontFamily: 'Raleway'
                    ),
                    onFieldSubmitted: (_) {
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter food item name";
                      }
                      return null;
                    },
                    decoration: _textFormFieldStyle("", "Food Name"),
                  ),
                ),),

              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    'Name',
                    style: TextStyle(
                        color: ColorUtils.primaryColor,
                        fontSize: 14,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold
                    ),
                  ),),),

              Align (
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      fontFamily: 'Raleway'
                    ),
                    onFieldSubmitted: (_) {
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter food item name";
                      }
                      return null;
                    },
                    decoration: _textFormFieldStyle("", "Food Name"),
                  ),
                ),),

            ],
          ),
        ),
      ),
    );
  }

  _textFormFieldStyle(String label, String hint) {
    return InputDecoration(
      counterText: "",
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w100,
        fontStyle: FontStyle.normal,
      ),
      alignLabelWithHint:false,
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
}