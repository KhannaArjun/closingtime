import 'package:closingtime/registration/sign_in.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: Scaffold(
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
                padding: const EdgeInsets.fromLTRB(5.0, 60.0, 5.0,0.0),
                child: const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et "
                      "dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut ",
                    style: TextStyle(
                      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5.0, 40.0, 5.0,0.0),
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
    );
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
            "Donor",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {},
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
          onPressed: () {},
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
            "Recipient",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
