import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:flutter/material.dart';

class VolunteerRegistration extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VolunteerRegistrationScreen(),
    );
  }
}

class VolunteerRegistrationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VolunteerRegistrationScreen();
  }
}

class _VolunteerRegistrationScreen extends State<VolunteerRegistrationScreen> {
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
                top: 150,
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
  final _formKey = GlobalKey<FormState>();
  var _userPersonNameController = TextEditingController(text: "kamal");
  var _userEmailController = TextEditingController(text: "kamal@gmail.com");
  var _userContactNumberController = TextEditingController(text: "07926166413");
  var _vehicleNumberController = TextEditingController(text: "UBP10AB");

  var _passwordFocusNode = FocusNode();
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
                _buildPersonName(context),
                _buildEmailField(context),
                _buildContactNumberField(context),
                _buildVehicleTypeField(context),
                _buildVehicleNumberField(context),
                _buildSubmitButton(context),
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


  Widget _buildIntroText() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 30),
          child: Text(
            "Volunteer Registration",
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

        },
        decoration: CommonStyles.textFormFieldStyle("Person Name", ""),
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
          str : _emailValidation(value.toString());
        },
        decoration: CommonStyles.textFormFieldStyle("Email", ""),
      ),
    );
  }

  String _emailValidation(String value) {
    bool emailValid =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    if (!emailValid) {
      return "Enter valid email address";
    } else {
      return "";
    }
  }

  Widget _buildContactNumberField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userContactNumberController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
          str : _emailValidation(value.toString());
        },
        decoration: CommonStyles.textFormFieldStyle("Contact Number", ""),
      ),
    );
  }

  Widget _buildVehicleTypeField(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
    Expanded(
    child: Row(
    children: [
        Radio(
        value: 1, groupValue: 'null', onChanged: (index) {}),
    Expanded(
    child: Text('Bike'),
    )
    ],
    ),
    flex: 1,
    ),
    Expanded(
    child: Row(
    children: [
    Radio(
    value: 1, groupValue: 'null', onChanged: (index) {}),
    Expanded(child: Text('Car'))
    ],
    ),
    flex: 1,
    )]);
  }

  Widget _buildVehicleNumberField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userContactNumberController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
          str : _emailValidation(value.toString());
        },
        decoration: CommonStyles.textFormFieldStyle("Vehicle Number", ""),
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
            _signUpProcess(context);
          },
        ),
      ),
    );
  }

  void _signUpProcess(BuildContext context) {

    final form = _formKey.currentState;
    if (form!.validate()) {
      //Do login stuff
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _clearAllFields() {
    setState(() {
      _userPersonNameController = TextEditingController(text: "");
      _userEmailController = TextEditingController(text: "");
      _userContactNumberController = TextEditingController(text: "");
      _vehicleNumberController = TextEditingController(text: "");
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