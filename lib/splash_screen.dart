import 'dart:async';

import 'package:closingtime/food_recipient/recipient_dashboard.dart';
import 'package:closingtime/registration/sign_in.dart';
import 'package:closingtime/registration/volunteer_registration.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:closingtime/volunteer/volunteer_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'food_donor/donor_dashboard.dart';

class SplashScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen()); // define it once at root level.
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 4),() {
      checkIsUserLoggedIn(context);


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: const Center(
            child: Text(
              'Closing Time!',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.primaryColor
              ),
            ),

        ),
      ));
  }


  void checkIsUserLoggedIn(BuildContext context) async
  {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String?  id = sp.getString(Constants.user_id);
    String?  role = sp.getString(Constants.role);

    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VolunteerRegistration("sfda")
    // ));


    if (id != null && id.isNotEmpty)
      {
        if (role == Constants.ROLE_DONOR)
          {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DonorDashboard()));
          }
        else if (role == Constants.ROLE_RECIPIENT)
        {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RecipientDashboard()));
        }
        else if (role == Constants.ROLE_VOLUNTEER)
        {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VolunteerDashboard()));
        }

      }
    else
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
        print(">>>>>>2");
      }
  }
}
