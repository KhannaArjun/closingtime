import 'package:closingtime/food_donor/profile_widget.dart';
import 'package:closingtime/registration/volunteer_registration.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:closingtime/volunteer/data_model/volunteer_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolunteerProfile extends StatefulWidget {
  const VolunteerProfile({Key? key}) : super(key: key);

  @override
  _VolunteerProfileState createState() => _VolunteerProfileState();
}

class _VolunteerProfileState extends State<VolunteerProfile> {

  VolunteerProfileModel? _volunteerProfileModel;

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
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: ColorUtils.volunteerPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: ColorUtils.volunteerGradient,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: ColorUtils.volunteerSurface,
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
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 30),
          ProfileWidget(
            imagePath: "https://source.unsplash.com/user/c_v_r/1600x900",
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(_volunteerProfileModel),
          const SizedBox(height: 24),
          buildPersonalDetails(_volunteerProfileModel),
          const SizedBox(height: 24),
          buildAddress(_volunteerProfileModel),
          const SizedBox(height: 20),
          buildEditProfileButton(_volunteerProfileModel),

        ],

      );
    }
  }

  Widget buildName(VolunteerProfileModel? volunteerProfileModel) => Column(
    children: [
      Text(
        volunteerProfileModel != null? volunteerProfileModel.name:"",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: ColorUtils.volunteerTextPrimary,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        volunteerProfileModel != null? volunteerProfileModel.email:"",
        style: const TextStyle(
          fontSize: 15,
          color: ColorUtils.volunteerTextSecondary,
        ),
      )
    ],
  );


  Widget buildPersonalDetails(VolunteerProfileModel? volunteerProfileModel) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorUtils.volunteerTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          color: ColorUtils.volunteerCardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                      "Contact Number",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      volunteerProfileModel != null? "+1 ${volunteerProfileModel.contactNumber}":''
                      ,
                      style: TextStyle(fontSize: 17),
                    ),),

                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Serving Distance",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      volunteerProfileModel != null? "0 - ${volunteerProfileModel.servingDistance} miles":''
                      ,
                      style: TextStyle(fontSize: 17),
                    ),),

                ],
              ),
            ), ), ),
      ],
    ),
  );

  Widget buildEditProfileButton(VolunteerProfileModel? volunteerProfileModel) => Column(
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => VolunteerRegistration("", "", volunteerProfileModel)));
            if (result == true){
              getUserDetails();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorUtils.volunteerPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          label: const Text('Edit Profile'),
          icon: const Icon(Icons.edit),
        )
      ]
  );


  Widget buildAddress(VolunteerProfileModel? volunteerProfileModel) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorUtils.volunteerTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          color: ColorUtils.volunteerCardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                      volunteerProfileModel != null? volunteerProfileModel.address:"",
                      style: TextStyle(fontSize: 17),
                    ),),
                ],
              ),
            ), ), ),
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
    String servingDistance = sharedPreferences.getString(Constants.serving_distance) ?? '';
    String contact = sharedPreferences.getString(Constants.contact) ?? '';
    String address = sharedPreferences.getString(Constants.address) ?? '';
    double lat = sharedPreferences.getDouble(Constants.lat) ?? 0.0;
    double lng = sharedPreferences.getDouble(Constants.lng) ?? 0.0;

    VolunteerProfileModel data = VolunteerProfileModel(address: address, servingDistance: servingDistance, code: "+1", contactNumber: contact, email: email, lat: lat, lng: lng, name: name, placeId: "", role: Constants.ROLE_DONOR, userId: userId);

    setState(() {
      _volunteerProfileModel = data;
    });

    // getDonorProfileFromApi(userId);
  }
}