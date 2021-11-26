import 'dart:convert';

import 'package:closingtime/food_donor/donor_dashboard.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/network/entity/donor/donor_registration%7C_model.dart';
import 'package:closingtime/registration/sign_in.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonorRegistration extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DonorRegistrationScreen(),
    );
  }
}

class DonorRegistrationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DonorRegistrationScreen();
  }
}

class _DonorRegistrationScreen extends State<DonorRegistrationScreen> {


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
                    padding: EdgeInsets.only(top: 80),
                    child: Text(
                      "Closing Time!",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 25),
                    ),
                  )),
              Positioned(
                top: 140,
                left: 10,
                right: 10,
                child: LoginFormWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginFormWidgetState();
  }
}

class _LoginFormWidgetState extends State<LoginFormWidget> {

  bool dismiss_loading = false;
  late BuildContext loadingContext;
  late ProgressDialog pd;


  final _formKey = GlobalKey<FormState>();
  var _userPersonNameController = TextEditingController(text: "kamal");
  var _userRestaurantNameController = TextEditingController(text: "KripyKreme");
  var _userEmailController = TextEditingController(text: "kamal@gmail.com");
  var _userPasswordController = TextEditingController(text: "");
  var _userContactNumbeCodeController = TextEditingController(text: "+1");
  var _userContactNumberController = TextEditingController(text: "07926166413");
  var _userCountryNameController = TextEditingController(text: "United States");
  var _userAreaNameController = TextEditingController(text: "Watford");
  var _userStreetNameController = TextEditingController(text: "12 southsea avenue");
  var _userPostalCodeController = TextEditingController(text: "WD187NJ");
  var _emailFocusNode = FocusNode();
  var _passwordFocusNode = FocusNode();
  bool _autoValidate = false;
  bool _progressBarActive = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Column(
              children: <Widget>[
                _buildIntroText(),
                _buildPersonName(context),
                _buildRestaurantName(context),
                _buildEmailField(context),
                _buildPasswordField(context),
                _buildContactNumberField(context),
                _buildAddressField(context),
                _buildCountryNameField(context),
                _buildAreaNameField(context),
                _buildStreetNameField(context),
                _buildPostalCodeField(context),
                //_buildFoodNameField(context),
                //_buildFoodDescField(context),
                _progressBarActive == true? CommonStyles.loadingBar(context): _buildSubmitButton(context),

                //_buildLoginOptionText(),
                //_buildSocialLoginRow(context),
              ],
            ),
          ),
          _buildSignUp(),
        ],
      ),
    );
  }

  Widget __buildTwitterButtonWidget(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: RaisedButton(
            color: Color.fromRGBO(16, 161, 250, 1.0),
            child: Image.asset(
              "assets/images/ic_twitter.png",
              width: 25,
              height: 25,
            ),
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0))),
      ),
    );
  }

  Widget _buildIntroText() {
    return Column(
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 30),
          child: Text(
            "Food Donor Registration",
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


  Widget _buildPersonName(BuildContext context)
  {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userPersonNameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        /*onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },*/
        validator: (value) {
  if (value == null || value.isEmpty) {
  return "Please enter person name";
  }
  return null;
  },
        decoration: CommonStyles.textFormFieldStyle("Person Name", ""),
      ),
    );
  }

  Widget _buildRestaurantName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userRestaurantNameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
    if (value == null || value.isEmpty) {
    return "Please enter business name";
    }
    return null;
        },
        decoration: CommonStyles.textFormFieldStyle("Business/Entity Name", ""),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userEmailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
          if (!_emailValidation(value.toString()))
          {
            return "Please enter valid email";
          }
          return null;
        },
        decoration: CommonStyles.textFormFieldStyle("Email", ""),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userPasswordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
          print("hey");
          if (value == null || value.isEmpty)
            {
              return "Please enter password";
            }
          return null;
        },
        decoration: CommonStyles.textFormFieldStyle("Password", ""),
      ),
    );
  }

  bool _emailValidation(String value) {
    bool emailValid = false;
    if (value != null && value.isNotEmpty)
      {
        emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
      }
    else
      {
        emailValid = false;
      }

    return emailValid;
  }

  Widget _buildContactNumberField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Row(
        children: [
          Flexible(
            child: Container(
              width: 35,
              child: TextFormField(
                readOnly: true,
            showCursor: false,
            controller: _userContactNumbeCodeController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,

            validator: (value) {
              if (value == null || value.isEmpty)
              {

                return "Please enter country code";
              }
              return null;

            },
            decoration: CommonStyles.textFormFieldStyle("Code", ""),
          ),),),
          SizedBox(width: 40),
          Flexible (child: TextFormField(
            controller: _userContactNumberController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            validator: (value) {
              if (value == null || value.isEmpty)
              {
                return "Please enter valid contact number";
              }
              return null;

            },
            decoration: CommonStyles.textFormFieldStyle("Contact Number", ""),
          ),),
        ],
      )
    );
  }

  Widget _buildAddressField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: Row(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Address',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

    //   Padding(
    // padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
    // child: Container(
    // padding: EdgeInsets.symmetric(horizontal: 15.0),
    // width: double.infinity,
    // child: CustomRaisedButton(
    // child: const Text(
    // "Detect location",
    // style: TextStyle(
    // color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
    // ),
    // onPressed: () {
    // _signUpProcess(context);
    // },
    // ),
    // ),
    // );
        ],
      ),

    );
  }

  Widget _buildCountryNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        showCursor: false,
        readOnly: true,
        controller: _userCountryNameController,
        keyboardType: TextInputType.text,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
          str : if (value == null || value.isEmpty)
          {
            return "Please enter valid country";
          }
          return null;
        },
        decoration: CommonStyles.textFormFieldStyle("Country", ""),
      ),
    );
  }

  Widget _buildAreaNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userAreaNameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
          str : if (value == null || value.isEmpty)
          {
            return "Please enter valid area name";
          }
          return null;
        },
        decoration: CommonStyles.textFormFieldStyle("Area Name", ""),
      ),
    );
  }

  Widget _buildStreetNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userStreetNameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
          str : if (value == null || value.isEmpty)
          {
            return "Please enter valid street name";
          }
          return null;
        },
        decoration: CommonStyles.textFormFieldStyle("Street Name", ""),
      ),
    );
  }

  Widget _buildPostalCodeField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userPostalCodeController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
          str :  if (value == null || value.isEmpty)
          {
            return "Please enter valid postal code";
          }
          return null;
        },
        decoration: CommonStyles.textFormFieldStyle("Postal Code", ""),
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
          child: const Text(
            "Submit",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {

            _signUpProcess(context);
          },
        ),
      ),
    );
  }

  void _signUpProcess(BuildContext context) {

    final form = _formKey.currentState;

      if (form!.validate()) {

      donorRegistrationApiCall(context);

        //getCurrentLocation();

    } else {
        print("hello");
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _clearAllFields() {
    setState(() {
      _userPersonNameController = TextEditingController(text: "");
      _userRestaurantNameController = TextEditingController(text: "");
      _userEmailController = TextEditingController(text: "");
      _userContactNumberController = TextEditingController(text: "");
      _userStreetNameController = TextEditingController(text: "");
      _userPostalCodeController = TextEditingController(text: "");
    });
  }

  Widget _buildSignUp() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            const TextSpan(
              text: "Have an Account? ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = ()
              {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignIn()));
              },
              text: 'Login',
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void donorRegistrationApiCall(BuildContext context)
  {
    // pd = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    // pd.style(message: "Loading");
    // pd.show();

    setState(() {
      _progressBarActive = true;
    });

    Map body =
      {
        "name": _userPersonNameController.value.text,
        "business_name": _userRestaurantNameController.value.text,
        "email": _userEmailController.value.text,
        "password": _userPersonNameController.value.text,
        "contact_number": _userContactNumberController.value.text,
        "code":_userContactNumbeCodeController.value.text,
        "country": _userCountryNameController.value.text,
        "area_name": _userAreaNameController.value.text,
        "street_name": _userStreetNameController.value.text,
        "postcode": _userPostalCodeController.value.text
      };


    try
    {
      Future<FoodDonorRegistration> donorRegistrationResp = ApiService.donorRegistration(jsonEncode(body));
      donorRegistrationResp.then((value){
        setState(() {
          _progressBarActive = false;
        });
        print(value.message);
        print(value.data);
        // hideProgressDialog();

        if (!value.error)
          {
            if (value.message == "Inserted") {
              storeUserData(value.data.userId);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DonorDashboard()));
            }
            else if(value.message == Constants.user_exists)
              {
                Constants.showToast(value.message);
              }
          }
        else
        {
          Constants.showToast(value.message);
        }
      });

    }
    on Exception catch(e)
    {
      print(e);
    }
  }

  void apiCall(BuildContext context)
  {

    try
    {
      Future<dynamic> donorRegistrationResp = ApiService.test();
      donorRegistrationResp.then((value){
        print(value);

      });

    }
    on Exception catch(e)
    {
      Navigator.pop(context);
      print(e);
    }
  }

  void showLoadingDialog(BuildContext context)
  {

    pd = ProgressDialog(context, type: ProgressDialogType.Normal);
    pd.style(message: "Loading");
    pd.show();

  }


  void hideProgressDialog() {
    pd.hide();
  }

  void getCurrentLocation() async
  {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.latitude);
    print(_locationData.longitude);
  }


  void storeUserData(String userId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(Constants.user_id, userId);
  }


  }