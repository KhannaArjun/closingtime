import 'dart:convert';

import 'package:closingtime/food_donor/data_model/food_donated_list_data.dart';
import 'package:closingtime/food_donor/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_version/new_version.dart';

import 'ColorUtils.dart';


class CommonStyles {
  static textFormFieldStyle(String label, String hint) {
    return InputDecoration(
      counterText: "",
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

  static textFormFieldDecoration(String label, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      alignLabelWithHint:false,
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

  static textFormStyle()
  {
    return const TextStyle(
      color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 15,
        fontFamily: 'Raleway'
    );
  }

  static textFormStyleForAppBar(label)
  {
    return Text(
        label,
        style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        fontFamily: 'Raleway'
    ),);
  }

  static textFormNameField(String label)
  {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: _textFieldsNamePadding(),
        child: Text(
          label,
          style: TextStyle(
              color: ColorUtils.primaryColor,
              fontSize: 14,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold
          ),
        ),),);
  }

  static textFieldsPadding()
  {
    return const EdgeInsets.fromLTRB(15, 0, 15, 0);
  }


  static _textFieldsNamePadding()
  {
    return const EdgeInsets.fromLTRB(15, 0, 15, 0);
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

  static void showCustomDialog(Data addedFoodModel, context) {
    showGeneralDialog(

      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),

      context: context,
      pageBuilder: (_, __, ___,) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 650,
            width: 360,
            child: foodDescDialog(addedFoodModel, context),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }


  static Widget foodDescDialog(Data addedFoodModel, context)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15,),

        Align(
          alignment: Alignment.center,
          child: Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: CircleAvatar(
              backgroundImage: addedFoodModel.image.isEmpty? NetworkImage("https://source.unsplash.com/user/c_v_r/1600x900"):Image.memory(base64Decode(addedFoodModel.image)).image,
              radius: 50,
              backgroundColor: ColorUtils.primaryColor,
            ),
          ),
        ),

        const SizedBox(height: 15,),

        foodDescDialogTextHeadings("Food Name"),
        foodDescDialogTextValues(addedFoodModel.foodName),
        const SizedBox(height: 15,),

        foodDescDialogTextHeadings("Food Description"),
        foodDescDialogTextValues(addedFoodModel.foodDesc.isEmpty? "(No description)": addedFoodModel.foodDesc),
        const SizedBox(height: 15,),

        foodDescDialogTextHeadings("Allergen Information"),
        foodDescDialogTextValues(addedFoodModel.allergen.isEmpty? "(No Allergen information)": addedFoodModel.allergen),
        const SizedBox(height: 15,),

        foodDescDialogTextHeadings("Food Ingredients"),
        foodDescDialogTextValues(addedFoodModel.foodIngredients.isEmpty? "(No ingredients information)": addedFoodModel.foodIngredients),
        const SizedBox(height: 15,),

        foodDescDialogTextHeadings("Food Quantity"),
        foodDescDialogTextValues(addedFoodModel.quantity),
        const SizedBox(height: 15,),

        foodDescDialogTextHeadings("Pick up date"),
        foodDescDialogTextValues(addedFoodModel.pickUpDate),
        const SizedBox(height: 15,),

        foodDescDialogTextHeadings("Pick up address"),
        foodDescDialogTextValues(addedFoodModel.pickUpAddress),
        const SizedBox(height: 15,),

        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
          child:  ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(
                'Close'
            ),

          ),
          ),
        ),
      ],
    );
  }

  static Widget foodDescDialogTextHeadings(str)
  {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 0,0),
      child: Text(
        str,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  static Widget foodDescDialogTextValues(String str)
  {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 0,0),
      child:Text(
        str,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  static Widget dropDown(List<String> dropDownList) {
    return DropdownButton<String>(
      items: dropDownList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (_) {},
    );
  }


}