import 'dart:convert';
import 'dart:math';

import 'package:closingtime/food_donor/donor_dashboard.dart';
import 'package:closingtime/food_donor/food_donor_dashboard.dart';
import 'package:closingtime/food_recipient/recipient_dashboard.dart';
import 'package:closingtime/login_providers/login_providers.dart';
import 'package:closingtime/main.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/network/entity/login_model.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:closingtime/volunteer/volunteer_dashboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
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

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                child: CommonStyles.layoutBackgroundShape(),
                //decoration: BoxDecoration(color: ColorUtils.appBarBackgroundForSignUp),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/14),
                    child: SizedBox(
                      height: 230,
                      width: 200,
                      child: Image.asset('assets/images/logo_white.png',)
                    ),
                  )),
              Positioned(
                top: 300,
                left: 10,
                right: 10,
                child: LoginWidget(),
              )
            ],
          ),
        ),
      ),),
    );
  }
}

// class LoginFormWidget extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _LoginWidgetState();
//   }
// }

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginWidgetState();
  }
}

class _LoginWidgetState extends State<LoginWidget> {

  final _loginProvider = LoginProvider();

  String fb_token = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getFirebaseTokeFromSP().then((value)
    {
      fb_token = value;

    });
  }

  Future<String> getFirebaseTokeFromSP() async
  {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? fb_token = sp.getString(Constants.firebase_token);
    if (fb_token != null)
    {
      return fb_token;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child:
      Card(

        elevation: 10,
        child: Column(
          children: <Widget>[

            const SizedBox(
              height: 50,
            ),

            SignInButton(

              Buttons.GoogleDark,
              text: "Sign in with Google",
              onPressed: () {

                _loginProvider.googleSignIn().then((value) {
                  if (value.isNotEmpty)
                  {
                    _email = value;
                    checkIsUserExists(context);
                  }
                  else
                    {
                      Constants.showToast("Unable to fetch your email, please try again");
                    }
                });

              },

            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                  'or'
              ),
            ),


            SignInButton(
              Buttons.AppleDark,
              text: "Sign in with Apple",
              onPressed: () {
                _loginProvider.signInWithApple().then((value)
                    {
                      if (value != null)
                      {

                        _email = value;

                        checkIsUserExists(context);
                      }
                      else
                        {
                          Constants.showToast("Please try again");
                        }
                    }
                );
                //LoginProvider.isLoggedIn();
              },
            ),

            SizedBox(
              height: 50,
            ),

            // ElevatedButton(
            //     onPressed: () {
            //       //showLoaderDialog(context);
            //     },
            //   child: Text(
            //     'Click'
            //   ),
            // )

          ],
        ),
      ),
    );
  }


  Widget _buildIntroText() {
    return Column(
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 30),
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

  String _email = "";

  void loginApiCall()
  {

    setState(() {
      _progressBarActive = true;
    });

    Map body = {
      'email': _email,
    };

    Future<LoginModel> loginModel = ApiService.login(jsonEncode(body));

    loginModel.then((value) {

      setState(() {
        _progressBarActive = false;
      });

      if(value.data.userId != null)
      {
        if (value.data.userId.isNotEmpty)
        {
          //storeUserData(value.data.userId, "");
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DonorDashboard()));
        }
        else
        {
          Constants.showToast("Please try again");
        }
      }
      else{
        Constants.showToast(value.message);

      }
    }
    );
  }

  late final BuildContext ctx;
  late String _platform = "";

  void checkIsUserExists(BuildContext context)
  {
    if (fb_token.isEmpty)
      {
        getFirebaseTokeFromSP().then((value)
        {
          fb_token = value;
          // print("fb_token");
        });
      }


    ctx = context;

    showLoaderDialog(ctx);

    setState(() {
      _progressBarActive = true;
    });

    Map body = {
      'email': _email,
      "firebase_token": fb_token
    };

    // print(body);

    Future<dynamic> response = ApiService.checkIsUserExists(jsonEncode(body));

    response.then((value) {

      // print(value);

      setState(() {
        _progressBarActive = false;
      });

      Navigator.pop(ctx);

      if(value['message'].toString() == Constants.user_exists)
      {
        var data = value['data'];

        if (data['role'] == Constants.ROLE_DONOR)
          {

            storeUserData(data['user_id'], data['name'], data['business_name'], data['email'], data['contact_number'], data['role'], data['address'], data['lat'], data['lng']);

            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                DonorDashboard()), (route) => false);

            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => DonorDashboard()));
          }
        else if (data['role'] == Constants.ROLE_RECIPIENT) {
          storeUserData(data['user_id'], data['name'], data['business_name'], data['email'], data['contact_number'], data['role'], data['address'], data['lat'], data['lng']);
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              RecipientDashboard()), (route) => false);
        }
        else{
          storeUserDataForVolunteer(data['user_id'], data['name'], data['serving_distance'], data['email'], data['contact_number'], data['role'], data['address'], data['lat'], data['lng']);
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              VolunteerDashboard()), (route) => false);
        }

      }
      else if (value['message'].toString() == Constants.new_user)
        {
          //Navigator.of(context).push( MaterialPageRoute(builder: (context) => RolePreferenceScreen(_email)));

          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              RolePreferenceScreen(_email)), (route) => false);
        }
      }

    );
  }

  void getFbToken()
  {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // await messaging.setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );



    messaging.getToken().then((token){

     fb_token = token!;

      // _storeFirebaseToken(token);
    });

  }

  // Widget _buildAppleSignIn(BuildContext context)
  // {
  //   return Center(
  //     child: SignInWithAppleButton(
  //
  //       onPressed: () async {
  //         final credential = await SignInWithApple.getAppleIDCredential(
  //           scopes: [
  //             AppleIDAuthorizationScopes.email,
  //             AppleIDAuthorizationScopes.fullName,
  //
  //           ],);
  //
  //         print(credential.email);
  //         print(credential.userIdentifier);
  //         },
  //   ),);
  // }

  storeUserDataForVolunteer(id, name, serving_distance, email, contact, role, address, lat, lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.user_id, id);
    prefs.setString(Constants.name, name);
    prefs.setString(Constants.serving_distance, serving_distance);
    prefs.setString(Constants.email, email);
    prefs.setString(Constants.contact, contact);
    prefs.setString(Constants.address, address);
    prefs.setDouble(Constants.lat, lat);
    prefs.setDouble(Constants.lng, lng);
    prefs.setString(Constants.role, role);
  }

  storeUserData(id, name, business_name, email, contact, role, address, lat, lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.user_id, id);
    prefs.setString(Constants.name, name);
    prefs.setString(Constants.business_name, business_name);
    prefs.setString(Constants.email, email);
    prefs.setString(Constants.contact, contact);
    prefs.setString(Constants.address, address);
    prefs.setDouble(Constants.lat, lat);
    prefs.setDouble(Constants.lng, lng);
    prefs.setString(Constants.role, role);
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content:  Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}



// class _LoginFormWidgetState extends State<LoginFormWidget> {
//   final _formKey = GlobalKey<FormState>();
//   var _userEmailController = TextEditingController(text: "kamal@gmail.com");
//   var _userPasswordController = TextEditingController(text: "kamal");
//   var _emailFocusNode = FocusNode();
//   var _passwordFocusNode = FocusNode();
//   bool _isPasswordVisible = true;
//   bool _autoValidate = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       autovalidate: _autoValidate,
//       child: Column(
//         children: <Widget>[
//           Card(
//             elevation: 10,
//             child: Column(
//               children: <Widget>[
//
//                 _buildIntroText(),
//                 _buildEmailField(context),
//                 _buildPasswordField(context),
//                 //_buildForgotPasswordWidget(context),
//                 _progressBarActive == true? CommonStyles.loadingBar(context):_buildSignInButton(context),
//                 //_buildLoginOptionText(),
//                 //_buildSocialLoginRow(context),
//               ],
//             ),
//           ),
//           _buildSignUp(),
//         ],
//       ),
//     );
//   }
//
//
//   buildShowDialog(BuildContext context) {
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         });
//   }
//
//   Widget _buildSocialLoginRow(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
//       child: Row(
//         children: <Widget>[
//           __buildFacebookButtonWidget(context),
//           __buildTwitterButtonWidget(context)
//         ],
//       ),
//     );
//   }
//
//   Widget __buildTwitterButtonWidget(BuildContext context) {
//     return Expanded(
//       flex: 1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: RaisedButton(
//             color: Color.fromRGBO(16, 161, 250, 1.0),
//             child: Image.asset(
//               "assets/images/ic_twitter.png",
//               width: 25,
//               height: 25,
//             ),
//             onPressed: () {},
//             shape: RoundedRectangleBorder(
//                 borderRadius: new BorderRadius.circular(30.0))),
//       ),
//     );
//   }
//
//   Widget __buildFacebookButtonWidget(BuildContext context) {
//     return Expanded(
//       flex: 1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: RaisedButton(
//             color: Color.fromRGBO(42, 82, 151, 1.0),
//             child: Image.asset(
//               "assets/images/ic_fb.png",
//               width: 35,
//               height: 35,
//             ),
//             onPressed: () {},
//             shape: RoundedRectangleBorder(
//                 borderRadius: new BorderRadius.circular(30.0))),
//       ),
//     );
//   }
//
//   Widget _buildLoginOptionText() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Text(
//         "Or sign up with social account",
//         style: TextStyle(
//             fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
//
//   Widget _buildIntroText() {
//     return Column(
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(top: 5, bottom: 30),
//           child: Text(
//             "Please Login",
//             style: TextStyle(
//                 color: Colors.black54,
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLogo() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10),
//       child: Image.asset(
//         "assets/images/ic_launcher.png",
//         height: 100,
//         width: 100,
//       ),
//     );
//   }
//
//   String _userNameValidation(String value) {
//     if (value.isEmpty) {
//       return "Please enter valid user name";
//     } else {
//       return "";
//     }
//   }
//
//   Widget _buildEmailField(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
//       child: TextFormField(
//         controller: _userEmailController,
//         keyboardType: TextInputType.emailAddress,
//         textInputAction: TextInputAction.next,
//         onFieldSubmitted: (_) {
//           FocusScope.of(context).requestFocus(_passwordFocusNode);
//         },
//         validator: (value) {
//           str : if (!_emailValidation(value.toString()))
//           {
//             return "Please enter valid email";
//           }
//           return null;
//         },
//         decoration: CommonStyles.textFormFieldStyle("Email", ""),
//       ),
//     );
//   }
//   bool _emailValidation(String value) {
//     bool emailValid = false;
//     if (value != null && value.isNotEmpty)
//     {
//       emailValid =
//           RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
//     }
//     else
//     {
//       emailValid = false;
//     }
//
//     return emailValid;
//   }
//
//   Widget _buildPasswordField(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
//       child: TextFormField(
//         controller: _userPasswordController,
//         keyboardType: TextInputType.text,
//         textInputAction: TextInputAction.next,
//         onFieldSubmitted: (_) {
//           FocusScope.of(context).requestFocus(_emailFocusNode);
//         },
//         validator: (value) {
//           str :  if (value == null || value.isEmpty)
//           {
//             return "Please enter password";
//           }
//           return null;
//         },
//         obscureText: _isPasswordVisible,
//         decoration: InputDecoration(
//           labelText: "Password",
//           hintText: "",
//           labelStyle: TextStyle(color: Colors.black),
//           alignLabelWithHint: true,
//           contentPadding: EdgeInsets.symmetric(vertical: 5),
//           suffixIcon: IconButton(
//               icon: Icon(
//                 _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _isPasswordVisible = !_isPasswordVisible;
//                 });
//               }),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.black,
//             ),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.black, width: 2),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildForgotPasswordWidget(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10.0),
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: FlatButton(
//             onPressed: () {},
//             child: Text(
//               'Forgot your password ?',
//               style:
//               TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
//             )),
//       ),
//     );
//   }
//
//   Widget _buildSignInButton(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 15.0),
//         width: double.infinity,
//         child: CustomRaisedButton(
//           child: Text(
//             "Login",
//             style: TextStyle(
//                 color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           onPressed: () {
//             _signInProcess(context);
//
//             //loginApiCall();
//             // Navigator.of(context).push(MaterialPageRoute(builder: (context) => FoodDonorDashboard()));
//
//           },
//         ),
//       ),
//     );
//   }
//
//   void _signInProcess(BuildContext context) {
//
//     final form = _formKey.currentState;
//     if (form!.validate()) {
//       //Do login stuff
//       loginApiCall();
//     } else {
//       setState(() {
//         _autoValidate = true;
//       });
//     }
//   }
//
//   void _clearAllFields() {
//     setState(() {
//       _userEmailController = TextEditingController(text: "");
//       _userPasswordController = TextEditingController(text: "");
//     });
//   }
//
//   Widget _buildSignUp() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 15),
//       child: RichText(
//         text: TextSpan(
//           style: DefaultTextStyle.of(context).style,
//           children: <TextSpan>[
//             TextSpan(
//               text: "Don't have an Account ? ",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//             TextSpan(
//               recognizer: TapGestureRecognizer()..onTap = ()
//               {
//                 //Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainScreen()));
//                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonorRegistration()));
//               },
//               text: 'Register',
//               style: TextStyle(
//                   fontWeight: FontWeight.w800,
//                   color: Colors.orange,
//                   fontSize: 14),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   void loginApiCall()
//   {
//
//     setState(() {
//       _progressBarActive = true;
//     });
//
//
//     Map body = {
//       'email':_userEmailController.value.text,
//       'password':_userPasswordController.value.text
//     };
//
//     Future<LoginModel> loginModel = ApiService.login(jsonEncode(body));
//
//     loginModel.then((value) {
//
//       setState(() {
//         _progressBarActive = false;
//       });
//       print(value.data.toString());
//
//       if(value.data.userId != null)
//         {
//           if (value.data.userId.isNotEmpty)
//           {
//             storeUserData(value.data.userId);
//             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DonorDashboard()));
//           }
//           else
//           {
//             print("Error");
//             Constants.showToast("Please try again");
//           }
//         }
//       else{
//         Constants.showToast(value.message);
//
//       }
//     }
//     );
//   }
//
//   Widget appleGoogleSignIn(BuildContext context)
//   {
//
//   }
//
//
//
//
//
//   storeUserData(value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString(Constants.user_id, value);
//   }
// }