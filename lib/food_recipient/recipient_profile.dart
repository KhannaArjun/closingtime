import 'dart:convert';

import 'package:closingtime/food_donor/data_model/donor_profile_model.dart';
import 'package:closingtime/food_donor/profile_widget.dart';
import 'package:closingtime/food_recipient/recipient_dashboard.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/registration/recipient_registration.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_model/recipient_profile_model.dart';

class RecipientProfile extends StatefulWidget {
  @override
  _RecipientProfileState createState() => _RecipientProfileState();
}

class _RecipientProfileState extends State<RecipientProfile> {

  RecipientProfileModel? recipientProfileModel;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // setState(() {
    //   isLoading = true;
    // });

    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    //final user = UserPreferences.myUser;

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body:
      // recipientProfileModel == null? Container():
      showLoadingBar()

    );
  }


  Widget showLoadingBar()
  {
    if (isLoading == true)
    {
      return Align(
          alignment:  Alignment.center,
          child: CommonStyles.loadingBar(context),
      );
    }
    else
      {
        return ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 30),
            ProfileWidget(
              imagePath: "https://source.unsplash.com/user/c_v_r/1600x900",
              onClicked: () async {},
            ),
            const SizedBox(height: 24),
            buildName(recipientProfileModel),
            const SizedBox(height: 24),
            buildPersonalDetails(recipientProfileModel),
            const SizedBox(height: 24),
            buildAddress(recipientProfileModel),
            const SizedBox(height: 20),

            buildEditProfileButton(recipientProfileModel),
          ],
        );
      }
  }

  Widget buildName(RecipientProfileModel? _recipientProfileModel) => Column(
    children: [
      Text(
        _recipientProfileModel != null?_recipientProfileModel.name:'',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        _recipientProfileModel != null?_recipientProfileModel.email:'',
        style: TextStyle(fontSize: 15, color: Colors.grey),
      )
    ],
  );


  Widget buildPersonalDetails(RecipientProfileModel? _recipientProfileModel) => Container(
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
                      _recipientProfileModel != null?_recipientProfileModel.businessName:''
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
                      _recipientProfileModel != null? "+1 ${_recipientProfileModel.contactNumber}":'',
                      style: TextStyle(fontSize: 17),
                    ),),

                ],
              ),
            ),), ),
      ],
    ),
  );

  Widget buildEditProfileButton(RecipientProfileModel? recipientProfileModel) => Column(
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipientRegistration("", recipientProfileModel)));
            if (result == true){
              getUserDetails();
            }
          },
          label: const Text('Edit Profile'),
          icon: const Icon(Icons.edit),
        )
      ]
  );

  // Widget buildAddress(RecipientProfileModel _recipientProfileModel) => Container(
  //   padding: EdgeInsets.symmetric(horizontal: 48),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Address',
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(height: 12),
  //       Card(
  //         elevation: 12,
  //         child: Container(
  //           width: 500,
  //           child: Padding(
  //             padding: EdgeInsets.all(10),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
  //                   child: Text(
  //                     "Street",
  //                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //                   ),),
  //                 Padding(
  //                   padding: EdgeInsets.all(5),
  //                   child: Text(
  //                     _recipientProfileModel != null?_recipientProfileModel.streetName:''
  //                     ,
  //                     style: TextStyle(fontSize: 17),
  //                   ),),
  //                 Padding(
  //                   padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
  //                   child: Text(
  //                     "Area",
  //                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //                   ),),
  //                 Padding(
  //                   padding: EdgeInsets.all(5),
  //                   child: Text(
  //                     _recipientProfileModel != null?_recipientProfileModel.area:''
  //                     ,
  //                     style: TextStyle(fontSize: 17),
  //                   ),),
  //                 Padding(
  //                   padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
  //                   child: Text(
  //                     "Postcode",
  //                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //                   ),),
  //                 Padding(
  //                   padding: EdgeInsets.all(5),
  //                   child: Text(
  //                     _recipientProfileModel != null?_recipientProfileModel.postcode:''
  //                     ,
  //                     style: TextStyle(fontSize: 17),
  //                   ),),
  //                 Padding(
  //                   padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
  //                   child: Text(
  //                     "Country",
  //                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //                   ),),
  //                 Padding(
  //                   padding: EdgeInsets.all(5),
  //                   child: Text(
  //                     _recipientProfileModel != null?_recipientProfileModel.country:''
  //                     ,
  //                     style: TextStyle(fontSize: 17),
  //                   ),),
  //               ],
  //             ),
  //           ),), ),
  //     ],
  //   ),
  // );

  Widget buildAddress(RecipientProfileModel? _recipientProfileModel) => Container(
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
                    padding: EdgeInsets.all(5),
                    child: Text(
                      _recipientProfileModel != null?_recipientProfileModel.address:'',
                      style: TextStyle(fontSize: 17),
                    ),),
                ],
              ),
            ),), ),
      ],
    ),
  );

  String userId = "";


  void getUserDetails() async
  {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    userId = sharedPreferences.getString(Constants.user_id) ?? '';
    String email = sharedPreferences.getString(Constants.email) ?? '';
    String name = sharedPreferences.getString(Constants.name) ?? '';
    String business_name = sharedPreferences.getString(Constants.business_name) ?? '';
    String contact = sharedPreferences.getString(Constants.contact) ?? '';
    String address = sharedPreferences.getString(Constants.address) ?? '';
    double lat = sharedPreferences.getDouble(Constants.lat) ?? 0.0;
    double lng = sharedPreferences.getDouble(Constants.lng) ?? 0.0;

    RecipientProfileModel data = RecipientProfileModel(address: address, businessName: business_name, code: "+1", contactNumber: contact, email: email, lat: lat, lng: lng, name: name, placeId: "", role: Constants.ROLE_RECIPIENT, userId: userId);


    setState(() {
      recipientProfileModel = data;
    });


    // getRecipientProfileFromApi(userId);
  }

  late BuildContext ctx;

  void getRecipientProfileFromApi( userId)
  {

    Map body = {
      "user_id": userId
    };

    try
    {
      Future<RecipientProfileResponse> donorResponse = ApiService.getRecipientProfile(jsonEncode(body));
      donorResponse.then((value){

        setState(() {
          isLoading = false;
        });

        print(value.data.toString());
        if (!value.error)
        {
          if (value.data != null)
          {
            setState(() {
              recipientProfileModel  = value.data;
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