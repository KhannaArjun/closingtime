import 'dart:convert';

import 'package:closingtime/food_donor/data_model/donor_profile_model.dart';
import 'package:closingtime/food_donor/profile_widget.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/registration/donor_registration.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonorProfile extends StatefulWidget {
  const DonorProfile({Key? key}) : super(key: key);

  @override
  _DonorProfileState createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {

  DonorProfileModel? donorProfileModel;

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
      // donorProfileModel == null? Container():
      showLoadingBar(),

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
  buildName(donorProfileModel),
  const SizedBox(height: 24),
  buildPersonalDetails(donorProfileModel),
  const SizedBox(height: 24),
  buildAddress(donorProfileModel),
      const SizedBox(height: 20),
    buildEditProfileButton(donorProfileModel),

    ],

      );
    }
  }

  Widget buildName(DonorProfileModel? donorProfileModel) => Column(
    children: [
      Text(
        donorProfileModel != null? donorProfileModel.name:"",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        donorProfileModel != null? donorProfileModel.email:"",
        style: TextStyle(fontSize: 15, color: Colors.grey),
      )
    ],
  );


  Widget buildPersonalDetails(DonorProfileModel? donorProfileModel) => Container(
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
          child: SizedBox(
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
                      donorProfileModel != null? "+1 ${donorProfileModel.contactNumber}":''
                      ,
                      style: TextStyle(fontSize: 17),
                    ),),

                ],
              ),
            ),), ),
      ],
    ),
  );

  Widget buildEditProfileButton(DonorProfileModel? donorProfileModel) => Column(
    children: [
      ElevatedButton.icon(
        onPressed: () async {
          var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonorRegistration("", donorProfileModel)));
          if (result == true){
            getUserDetails();
          }
        },
        label: const Text('Edit Profile'),
        icon: const Icon(Icons.edit),
      )
    ]
  );

  // Widget buildAddress(DonorProfileModel donorProfileModel) => Container(
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
  //                     donorProfileModel != null?donorProfileModel.streetName:''
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
  //                     donorProfileModel != null?donorProfileModel.area:''
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
  //                     donorProfileModel != null?donorProfileModel.postcode:''
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
  //                     donorProfileModel != null?donorProfileModel.country:''
  //                     ,
  //                     style: TextStyle(fontSize: 17),
  //                   ),),
  //               ],
  //             ),
  //           ),), ),
  //     ],
  //   ),
  // );


  Widget buildAddress(DonorProfileModel? donorProfileModel) => Container(
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
          child: SizedBox(
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
                      donorProfileModel != null? donorProfileModel.address:"",
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
    String businessName = sharedPreferences.getString(Constants.business_name) ?? '';
    String contact = sharedPreferences.getString(Constants.contact) ?? '';
    String address = sharedPreferences.getString(Constants.address) ?? '';
    double lat = sharedPreferences.getDouble(Constants.lat) ?? 0.0;
    double lng = sharedPreferences.getDouble(Constants.lng) ?? 0.0;

    DonorProfileModel data = DonorProfileModel(address: address, businessName: businessName, code: "+1", contactNumber: contact, email: email, lat: lat, lng: lng, name: name, placeId: "", role: Constants.ROLE_DONOR, userId: userId);

    setState(() {
      donorProfileModel = data;
    });

    // getDonorProfileFromApi(userId);
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

        setState(() {
          isLoading = false;
        });
        if (!value.error)
        {
          setState(() {
            donorProfileModel  = value.data;
          });
                }
      }).catchError((onError)
      {
        setState(() {
          isLoading = false;
        });
        Constants.showToast(Constants.something_went_wrong);
      }
      );

    }
    on Exception {
      // print(e);
      Constants.showToast("Please try again");
    }

  }


}