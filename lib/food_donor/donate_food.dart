import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:flutter/material.dart';

class DonateFood extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _DonateFood(),
    );
  }
}


class _DonateFood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(

                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                child: CommonStyles.layoutBackgroundShape(),
                //decoration: BoxDecoration(color: ColorUtils.appBarBackgroundForSignUp),
              ),
              const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Text(
                      "Closing Time!",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 25),
                    ),
                  )),
              Positioned(
                top: 230,
                left: 10,
                right: 10,
                child: DonateFoodFormWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DonateFoodFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DonateFoodFormWidget();
  }
}

class _DonateFoodFormWidget extends State<DonateFoodFormWidget> {
  final _formKey = GlobalKey<FormState>();
  var _foodNameController = TextEditingController(text: "Donuts");
  var _foodDescController = TextEditingController(text: "There are 18 Donuts. It contains sugar.");
  var _foodQuantityController = TextEditingController(text: "18 units");
  var _foodPickUpDateController = TextEditingController(text: "18 units");

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Column(
              children: <Widget>[
                _buildIntroText(),
                _buildFoodNameField(context),
                _buildFoodDescField(context),
                _buildFoodQuantityField(context),
                _buildFoodPickUpDateField(context),
                _buildSubmitButton(context),
                //_buildLoginOptionText(),
                //_buildSocialLoginRow(context),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildIntroText() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 30),
          child: Text(
            "Food Donation Form",
            style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Image.asset(
        "assets/images/ic_launcher.png",
        height: 100,
        width: 100,
      ),
    );
  }

  Widget _buildFoodNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _foodNameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
        },
        validator: (value) {
        },
        decoration: CommonStyles.textFormFieldStyle("Food Name", ""),
      ),
    );
  }

  Widget _buildFoodDescField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _foodDescController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
        },
        validator: (value) {
        },
        decoration: CommonStyles.textFormFieldStyle("Food Description", ""),
      ),
    );
  }

  Widget _buildFoodQuantityField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _foodQuantityController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
        },
        validator: (value) {
        },
        decoration: CommonStyles.textFormFieldStyle("Food Quantity", ""),
      ),
    );
  }

  Widget _buildFoodPickUpDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _foodPickUpDateController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
        },
        validator: (value) {
        },
        decoration: CommonStyles.textFormFieldStyle("Food Pickup Date", ""),
      ),
    );
  }


  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: CustomRaisedButton(
          child: Text(
            "Submit",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
          },
        ),
      ),
    );
  }

  void _clearAllFields() {
    setState(() {

    });
  }

  Widget _buildSignUp() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
              text: "Have an Account? ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}