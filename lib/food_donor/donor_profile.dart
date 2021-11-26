import 'dart:convert';

import 'package:closingtime/food_donor/data_model/donor_profile_model.dart';
import 'package:closingtime/food_donor/profile_widget.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonorProfile extends StatefulWidget {
  @override
  _DonorProfileState createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {

  DonorProfileModel? donorProfileModel;

  @override
  void initState() {
    super.initState();

    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    //final user = UserPreferences.myUser;

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: donorProfileModel == null? Container():ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 30),
          ProfileWidget(
            imagePath: "https://source.unsplash.com/user/c_v_r/1600x900",
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(donorProfileModel!),
          const SizedBox(height: 24),
          buildPersonalDetails(donorProfileModel!),
          const SizedBox(height: 24),
          buildAddress(donorProfileModel!),
        ],
      ),
    );
  }

  Widget buildName(DonorProfileModel donorProfileModel) => Column(
    children: [
      Text(
        donorProfileModel.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        donorProfileModel.email,
        style: TextStyle(fontSize: 15, color: Colors.grey),
      )
    ],
  );


  Widget buildPersonalDetails(DonorProfileModel donorProfileModel) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 10,
          child: Container(
            width: 500,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Business/entity name",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      donorProfileModel != null?donorProfileModel.businessName:''
                      ,
                      style: TextStyle(fontSize: 17),
                    ),),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Contact Number",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      donorProfileModel != null?donorProfileModel.contactNumber:''
                      ,
                      style: TextStyle(fontSize: 17),
                    ),),

                ],
              ),
            ),), ),
      ],
    ),
  );

  Widget buildAddress(DonorProfileModel donorProfileModel) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 12,
          child: Container(
            width: 500,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Street",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      donorProfileModel != null?donorProfileModel.streetName:''
                      ,
                      style: TextStyle(fontSize: 17),
                    ),),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Area",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      donorProfileModel != null?donorProfileModel.area:''
                      ,
                      style: TextStyle(fontSize: 17),
                    ),),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Postcode",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      donorProfileModel != null?donorProfileModel.postcode:''
                      ,
                      style: TextStyle(fontSize: 17),
                    ),),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Country",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      donorProfileModel != null?donorProfileModel.country:''
                      ,
                      style: TextStyle(fontSize: 17),
                    ),),
                ],
              ),
            ),), ),
      ],
    ),
  );


  void getUserId() async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userId = sharedPreferences.getString(Constants.user_id) ?? '';

    getDonorProfileFromApi(userId);
  }

  void getDonorProfileFromApi(userId)
  {

    Map body = {
      "user_id": userId
    };

    try
    {
      Future<DonorProfileResponse> donorResponse = ApiService.getDonorProfile(jsonEncode(body));
      donorResponse.then((value){
        print(value.data.toString());
        if (!value.error)
        {
          if (value.data != null)
          {
            setState(() {
              donorProfileModel  = value.data;
            });
          }
          else
          {
            //Constants.showToast(Constants.empty);

          }
        }
      });

    }
    on Exception catch(e)
    {
      print(e);
      Constants.showToast("Please try again");
    }

  }


}