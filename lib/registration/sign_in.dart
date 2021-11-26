import 'dart:convert';
import 'dart:math';

import 'package:closingtime/food_donor/donor_dashboard.dart';
import 'package:closingtime/food_donor/food_donor_dashboard.dart';
import 'package:closingtime/main.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/network/entity/login_model.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'donor_registration.dart';


class SignIn extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginScreenState();
  }
}

bool _progressBarActive = false;

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Container(
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
                top: 270,
                left: 10,
                right: 10,
                child: LoginFormWidget(),
              )
            ],
          ),
        ),
      ),),
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
  final _formKey = GlobalKey<FormState>();
  var _userEmailController = TextEditingController(text: "kamal@gmail.com");
  var _userPasswordController = TextEditingController(text: "kamal");
  var _emailFocusNode = FocusNode();
  var _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = true;
  bool _autoValidate = false;

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
                _buildEmailField(context),
                _buildPasswordField(context),
                //_buildForgotPasswordWidget(context),
                _progressBarActive == true? CommonStyles.loadingBar(context):_buildSignInButton(context),
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


  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget _buildSocialLoginRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          __buildFacebookButtonWidget(context),
          __buildTwitterButtonWidget(context)
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

  Widget __buildFacebookButtonWidget(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: RaisedButton(
            color: Color.fromRGBO(42, 82, 151, 1.0),
            child: Image.asset(
              "assets/images/ic_fb.png",
              width: 35,
              height: 35,
            ),
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0))),
      ),
    );
  }

  Widget _buildLoginOptionText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Or sign up with social account",
        style: TextStyle(
            fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildIntroText() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 30),
          child: Text(
            "Please Login",
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

  String _userNameValidation(String value) {
    if (value.isEmpty) {
      return "Please enter valid user name";
    } else {
      return "";
    }
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
          str : if (!_emailValidation(value.toString()))
          {
            return "Please enter valid email";
          }
          return null;
        },
        decoration: CommonStyles.textFormFieldStyle("Email", ""),
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

  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userPasswordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        },
        validator: (value) {
          str :  if (value == null || value.isEmpty)
          {
            return "Please enter password";
          }
          return null;
        },
        obscureText: _isPasswordVisible,
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "",
          labelStyle: TextStyle(color: Colors.black),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
            onPressed: () {},
            child: Text(
              'Forgot your password ?',
              style:
              TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
            )),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: CustomRaisedButton(
          child: Text(
            "Login",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            _signInProcess(context);

            //loginApiCall();
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => FoodDonorDashboard()));

          },
        ),
      ),
    );
  }

  void _signInProcess(BuildContext context) {

    final form = _formKey.currentState;
    if (form!.validate()) {
      //Do login stuff
      loginApiCall();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _clearAllFields() {
    setState(() {
      _userEmailController = TextEditingController(text: "");
      _userPasswordController = TextEditingController(text: "");
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
              text: "Don't have an Account ? ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = ()
              {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainScreen()));
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonorRegistration()));
              },
              text: 'Register',
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


  void loginApiCall()
  {

    setState(() {
      _progressBarActive = true;
    });


    Map body = {
      'email':_userEmailController.value.text,
      'password':_userPasswordController.value.text
    };

    Future<LoginModel> loginModel = ApiService.login(jsonEncode(body));

    loginModel.then((value) {

      setState(() {
        _progressBarActive = false;
      });
      print(value.data.toString());

      if(value.data.userId != null)
        {
          if (value.data.userId.isNotEmpty)
          {
            storeUserData(value.data.userId);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DonorDashboard()));
          }
          else
          {
            print("Error");
            Constants.showToast("Please try again");
          }
        }
      else{
        Constants.showToast(value.message);

      }


    }
    );
  }

  storeUserData(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.user_id, value);
  }
}