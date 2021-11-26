import 'package:closingtime/registration/donor_registration.dart';
import 'package:closingtime/registration/sign_in.dart';
import 'package:closingtime/registration/volunteer_registration.dart';
import 'package:closingtime/splash_screen.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  runApp(SplashScreenApp());
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: LoaderOverlay(
        child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Closing Time!',
            style: TextStyle(
              color: ColorUtils.button_color
            ),
          ),
        ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 60.0, 5.0,0.0),
                child: const Text(
                  "“Feel what it’s like to truly starve, and I guarantee that you’ll forever think twice about wasting food.“",
                    style: TextStyle(
                      color: Colors.black, fontSize: 18, fontStyle: FontStyle.italic),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5.0, 60.0, 5.0,0.0),
                child: const Text(
                  "I'm a,",
                  style: TextStyle(
                      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),

              buildButtonDonor(context),
              buildButtonVolunteer(context),
              buildButtonRecipient(context),
            ],
          ),
        ),
      )),
      ));
  }



  Widget buildButtonDonor(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: CustomRaisedButton(
          height: 50,
          child: const Text(
            "Food Donor",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonorRegistration()));
          },
        ),
      ),
    );
  }

  Widget buildButtonVolunteer(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: CustomRaisedButton(
          height: 50,

          child: const Text(
            "Volunteer",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => VolunteerRegistration()));
          },
        ),
      ),
    );
  }

  Widget buildButtonRecipient(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: CustomRaisedButton(
          height: 50,

          child: const Text(
            "Food Recipient",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
