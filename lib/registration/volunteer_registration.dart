import 'dart:convert';

import 'package:closingtime/food_recipient/recipient_dashboard.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:closingtime/utils/google_places.dart';
import 'package:closingtime/utils/location_details_model.dart';
import 'package:closingtime/volunteer/MilesModel.dart';
import 'package:closingtime/volunteer/data_model/volunteer_profile_model.dart';
import 'package:closingtime/volunteer/data_model/volunteer_registration_model.dart';
import 'package:closingtime/volunteer/volunteer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolunteerRegistration extends StatelessWidget {
  // This widget is the root of your application.

  String _email = "";
  VolunteerProfileModel? _volunteerProfileModel;

  VolunteerRegistration(this._email, this._volunteerProfileModel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: CommonStyles.textFormStyleForAppBar("Volunteer Registration"),
          backgroundColor: Colors.blue,
          elevation: 0.0,
          titleSpacing: 10.0,
          centerTitle: true,
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
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: CommonStyles.layoutBackgroundShape(),
                  //decoration: BoxDecoration(color: ColorUtils.appBarBackgroundForSignUp),
                ),

                Positioned(
                  top: 50,
                  left: 10,
                  right: 10,
                  child: VolunteerRegistrationFormWidget(_email, _volunteerProfileModel),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VolunteerRegistrationFormWidget extends StatefulWidget {
  String _email = "";
  VolunteerProfileModel? _volunteerProfileModel;
  VolunteerRegistrationFormWidget(this._email, this._volunteerProfileModel);

  @override
  State<StatefulWidget> createState() {
    return _VolunteerRegistrationFormWidget(_email, _volunteerProfileModel);
  }
}

class _VolunteerRegistrationFormWidget extends State<VolunteerRegistrationFormWidget> {

  String _email = "", fb_token = "";

  VolunteerProfileModel? _volunteerProfileModel;
  _VolunteerRegistrationFormWidget(this._email, this._volunteerProfileModel);

  final _formKey = GlobalKey<FormState>();

  var _passwordFocusNode = FocusNode();
  bool _autoValidate = false;

  var _userPersonNameController;
  var _userEmailController;
  var _userContactNumberController;
  var _vehicleNumberController;
  var _userAddressFieldController;
  var _userContactNumbeCodeController;
  var selectedMiles = "";
  List<MilesModel> milesList = [];

  bool _progressBarActive = false;

  int _previouslySelectedItem = -1;

  String _selectedDistance = "0";


  @override
  void initState() {

    super.initState();

    _userPersonNameController = TextEditingController(text: _volunteerProfileModel == null? "" : _volunteerProfileModel!.name);
    _userEmailController = TextEditingController(text: _volunteerProfileModel == null? _email : _volunteerProfileModel!.email);
    _userContactNumberController = TextEditingController(text:  _volunteerProfileModel == null? "" : _volunteerProfileModel!.contactNumber);
    _userAddressFieldController = TextEditingController(text:  _volunteerProfileModel == null? "" : _volunteerProfileModel!.address);
    _userContactNumbeCodeController = TextEditingController(text: "+1");

    _selectedDistance = _volunteerProfileModel == null? "" : _volunteerProfileModel!.serving_distance;

    milesList.add( MilesModel("5", false));
    milesList.add( MilesModel("10", false));
    milesList.add( MilesModel("15", false));
    milesList.add( MilesModel("20", false));
    milesList.add( MilesModel("25", false));


    if (_volunteerProfileModel != null)
      {
        for(int i =0; i<milesList.length; i++)
        {
          MilesModel milesModel = milesList[i];
          if(_selectedDistance == milesModel.getItem)
          {

            milesModel.isSelected(true);
          }
        }

        setState(() {
          milesList;
        });

      }


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
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30,),

                CommonStyles.textFormNameField("Person Name"),
                _buildPersonName(context),
                const SizedBox(height: 30,),

                CommonStyles.textFormNameField("Email"),
                _buildEmailField(context),
                const SizedBox(height: 30,),

                _buildContactField(context),
                _buildContactNumberField(context),
                const SizedBox(height: 30,),

                _buildSelectMilesField(context),
                const SizedBox(height: 10,),
                _buildChooseMilesField(context),
                const SizedBox(height: 30,),

                CommonStyles.textFormNameField("Enter your Address"),
                _buildChooseAddressField(context),
                _progressBarActive == true? CommonStyles.loadingBar(context): _buildSubmitButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactField(BuildContext context) {
    return
      Row(
        children: [
          CommonStyles.textFormNameField("Code"),
          CommonStyles.textFormNameField("Contact Number"),
        ],
      );
  }

  Widget _buildSelectMilesField(BuildContext context) {
    return Row(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: CommonStyles.textFormNameField("Select serving radius in miles")
        ),
      ],
    );
  }


  Widget _buildPersonName(BuildContext context)
  {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(
        style: CommonStyles.textFormStyle(),
        controller: _userPersonNameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        /*onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },*/
        validator: (value) {

          if (value == null || value.isEmpty) {
            return "Please enter your name";
          }
          return null;

        },
        decoration: CommonStyles.textFormFieldDecoration("", "Person Name"),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(
        style: CommonStyles.textFormStyle(),
        showCursor: false,
        readOnly: true,
        controller: _userEmailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
          // str :  _emailValidation(value.toString());
        },
        decoration: CommonStyles.textFormFieldDecoration("", "Email"),
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

  Widget _buildChooseAddressField(BuildContext context) {
    return
      Padding(
        padding: CommonStyles.textFieldsPadding(),
        child: TextFormField(
            showCursor: false,
            readOnly: true,
            controller: _userAddressFieldController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            style: CommonStyles.textFormStyle(),
            onFieldSubmitted: (_) {
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter serving location";
              }
              return null;
            },
            decoration: CommonStyles.textFormFieldDecoration("Enter your serving location", ""),
            onTap: () async {
              _awaitReturnValueFromPlacesAutocomplete(context);

              // draggableScrollSheet();

              //modal(context);

            }),
      );
  }

  Widget _buildContactNumberField(BuildContext context) {
    return Padding(
        padding: CommonStyles.textFieldsPadding(),
        child: Row(
          children: [
            Flexible(
              child: SizedBox(
                width: 45,
                child: TextFormField(
                  style: CommonStyles.textFormStyle(),
                  maxLength: 2,
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
                  decoration: CommonStyles.textFormFieldDecoration("", "Code"),
                ),),),
            const SizedBox(width: 25),
            Flexible (child: TextFormField(
              maxLength: 10,
              controller: _userContactNumberController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              style: CommonStyles.textFormStyle(),
              onFieldSubmitted: (_) {

              },
              validator: (value) {
                if (value == null || value.isEmpty)
                {
                  return "Please enter valid contact number";
                }
                if (value.length != 10)
                {
                  return "Please enter valid contact number";
                }
                return null;

              },
              decoration: CommonStyles.textFormFieldDecoration("", "Contact Number"),
            ),),
          ],
        )
    );
  }


  Widget _buildChooseMilesField(BuildContext context) {
    return     Padding(
      padding: CommonStyles.textFieldsPadding(),
      child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ListView.builder(
            shrinkWrap:  true,
            scrollDirection: Axis.horizontal,
            itemCount: milesList.length,
            itemBuilder: (context,index){
              return Wrap(
                //color: Colors.grey,//selectedIndex==index?Colors.green:Colors.red,//now suppose selectedIndex and index from this builder is same then it will show the selected as green and others in red color
                children: [
                  _itemCard(context, milesList.elementAt(index), index),
                ],
              );
            },
          )
      ),
    );
  }

  Widget _itemCard(BuildContext context, MilesModel miles, int index)
  {
    return
      GestureDetector(

        onTap: () {

          if (_previouslySelectedItem == index)
            {
              return;
            }
          _selectedDistance = miles.getItem;
          setState(() {
            miles.isSelected(true);
            if (_previouslySelectedItem != -1)
              {
                milesList[_previouslySelectedItem].isSelected(false);
              }
            _previouslySelectedItem = index;

          });

        },
        child: Container(
      alignment: Alignment.center,
      height: 60,
      child: Card(
        color: miles.selected == true? ColorUtils.primaryColor : Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child:
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 7, 20, 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  miles.getItem,
                style: TextStyle(
                  color: miles.selected == true? Colors.white: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),

        ),
      ),
    ),);
  }


  late LocationDetailsModel locationDetailsModel;

  void _awaitReturnValueFromPlacesAutocomplete(BuildContext context) async {

    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AutoCompleteGooglePlaces(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(()
    {
      if (result != null) {
        locationDetailsModel = result;
        _userAddressFieldController.text = locationDetailsModel.address;
      }

    });
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

      if (_selectedDistance == "0")
        {
          Constants.showToast("Please choose serving radius");
          return;
        }

      _volunteerProfileModel == null? volunteerRegistrationApiCall(context) : volunteerUpdateProfileApiCall(context);

      //getCurrentLocation();

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


  void volunteerRegistrationApiCall(BuildContext context)
  {

    setState(() {
      _progressBarActive = true;
    });

    Map body =
    {
      "name": _userPersonNameController.value.text,
      "email": _userEmailController.value.text,
      "contact_number": _userContactNumberController.value.text,
      "serving_distance": _selectedDistance,
      "code":_userContactNumbeCodeController.value.text,
      "address": locationDetailsModel.address,
      "lat":locationDetailsModel.lat,
      "lng":locationDetailsModel.lng,
      "place_id":locationDetailsModel.placeId,
      "role": Constants.ROLE_VOLUNTEER,
      "firebase_token": fb_token
    };

    // print(jsonEncode(body));


    try
    {
      Future<VolunteerRegistrationResponse> donorRegistrationResp = ApiService.volunteerRegistration(jsonEncode(body));
      donorRegistrationResp.then((value){
        setState(() {
          _progressBarActive = false;
        });
        // print(value.message);
        // print(value.data);
        // // hideProgressDialog();

        if (!value.error)
        {
          if (value.message == "Inserted") {
            _storeUserData(value.data.userId, value.data.name, value.data.email, _selectedDistance, value.data.contactNumber, value.data.role, value.data.address, value.data.lat, value.data.lng );

            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => RecipientDashboard()));

            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                VolunteerDashboard()), (route) => false);
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
      // print(e);
    }
  }

  void volunteerUpdateProfileApiCall(BuildContext context)
  {

    setState(() {
      _progressBarActive = true;
    });

    Map body =
    {
      "name": _userPersonNameController.value.text,
      "email": _userEmailController.value.text,
      "contact_number": _userContactNumberController.value.text,
      "serving_distance": _selectedDistance,
      "code":_userContactNumbeCodeController.value.text,
      "address": locationDetailsModel.address,
      "lat":locationDetailsModel.lat,
      "lng":locationDetailsModel.lng,
      "place_id":locationDetailsModel.placeId,
      "role": Constants.ROLE_VOLUNTEER,
      "firebase_token": fb_token
    };

    // print(body.toString());

    try
    {
      Future<VolunteerRegistrationResponse> donorRegistrationResp = ApiService.volunteerRegistration(jsonEncode(body));
      donorRegistrationResp.then((value){
        setState(() {
          _progressBarActive = false;
        });
        // print(value.message);
        // print(value.data);
        // hideProgressDialog();

        if (!value.error)
        {
          if (value.message == "Inserted") {
            _storeUserData(value.data.userId, value.data.name, value.data.email, _selectedDistance, value.data.contactNumber, value.data.role, value.data.address, value.data.lat, value.data.lng );

            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => RecipientDashboard()));

            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                RecipientDashboard()), (route) => false);
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
      // print(e);
    }
  }

  _storeUserData(id, name, email, serving_distance, contact, role, address, lat, lng) async {
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

}