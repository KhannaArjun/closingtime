import 'dart:convert';

import 'package:closingtime/food_donor/data_model/donor_profile_model.dart';
import 'package:closingtime/food_donor/donor_dashboard.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/network/entity/donor/donor_registration_model.dart';
import 'package:closingtime/registration/sign_in.dart';
import 'package:closingtime/test.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:closingtime/utils/google_places.dart';
import 'package:closingtime/utils/location_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_place/google_place.dart';

class DonorRegistration extends StatelessWidget {

  String _email = "";
  DonorProfileModel? _donorProfileModel;

  DonorRegistration(String email, DonorProfileModel? donorProfileModel)
  {
    _email = email;
    _donorProfileModel = donorProfileModel;

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CommonStyles.textFormStyleForAppBar("Donor Registration"),
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
                // const Align(
                //     alignment: Alignment.topCenter,
                //     child: Padding(
                //       padding: EdgeInsets.only(top: 80),
                //       child: Text(
                //         "Closing Time!",
                //         style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.w800,
                //             fontSize: 25),
                //       ),
                //     )),
                Positioned(
                  top: 50,
                  left: 10,
                  right: 10,
                  child: LoginFormWidget(_email, _donorProfileModel),
                )
              ],
            ),
          ),
        ),
    );
  }
}


class LoginFormWidget extends StatefulWidget {

  String _email = "";
  DonorProfileModel? _donorProfileModel;

  LoginFormWidget(String email, DonorProfileModel? donorProfileModel)
  {
    _email = email;
    _donorProfileModel = donorProfileModel;
  }

  @override
  State<StatefulWidget> createState() {
    return _LoginFormWidgetState(_email, _donorProfileModel);
  }
}

class _LoginFormWidgetState extends State<LoginFormWidget> {

  String _email = "";
  DonorProfileModel? _donorProfileModel;
  _LoginFormWidgetState(String email, DonorProfileModel? donorProfileModel)
  {
    _email = email;
    _donorProfileModel = donorProfileModel;
  }

  bool dismiss_loading = false;
  late BuildContext loadingContext;
  late ProgressDialog pd;


  final _formKey = GlobalKey<FormState>();
  var _userPersonNameController;
  var _userRestaurantNameController;
  var _userPasswordController;
  var _userContactNumbeCodeController = TextEditingController(text: "+1");
  var _userContactNumberController;
  var _userCountryNameController = TextEditingController(text: "United States");

  var _emailFocusNode = FocusNode();
  var _passwordFocusNode = FocusNode();
  bool _autoValidate = false;
  bool _progressBarActive = false;

  var _userEmailController;
  var _userAddressFieldController;


  String fb_token = "";

  List<String> statesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _userPersonNameController = TextEditingController(text: _donorProfileModel == null? "": _donorProfileModel!.name);
    _userRestaurantNameController = TextEditingController(text: _donorProfileModel == null? "": _donorProfileModel!.businessName);
    // var _userPasswordController = TextEditingController(text: _donorProfileModel == null? "": _donorProfileModel!.name);
    _userContactNumberController = TextEditingController(text: _donorProfileModel == null? "": _donorProfileModel!.contactNumber);
    _userEmailController = TextEditingController(text: _donorProfileModel == null? _email: _donorProfileModel!.email);
    _userAddressFieldController = TextEditingController(text: _donorProfileModel == null? "": _donorProfileModel!.address);

    if (_donorProfileModel != null)
      {
        locationDetailsModel = LocationDetailsModel(_donorProfileModel!.address, _donorProfileModel!.lat, _donorProfileModel!.lng, _donorProfileModel!.placeId);
      }

    googlePlace = GooglePlace("AIzaSyC6BSkN2od9soYaSaiIou-Ctcop186rWPg");


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
                  // _buildIntroText(),
                  const SizedBox(height: 30,),

                  CommonStyles.textFormNameField("Person Name"),
                  _buildPersonName(context),
                  const SizedBox(height: 30,),

                  CommonStyles.textFormNameField("Business/Entity Name"),
                  _buildRestaurantName(context),
                  const SizedBox(height: 30,),

                  CommonStyles.textFormNameField("Email"),
                  _buildEmailField(context),
                  const SizedBox(height: 30,),

                  _buildContactField(context),
                  _buildContactNumberField(context),
                  const SizedBox(height: 30,),

                  // CommonStyles.textFormNameField("Address"),
                  // _buildAddressField(context),
                  // _buildStreetNameField(context),
                  // _buildAreaNameField(context),
                  // _buildStatesAutoCompleteTextField(context),
                  CommonStyles.textFormNameField("Enter your Address"),
                  _buildChooseAddressField(context),
                  const SizedBox(height: 30,),

                  //_buildStateNameField(context),
                  // _buildPostalCodeField(context),
                  // _buildCountryNameField(context),

                  //_buildGoogleAutocomplete(),


                  //_buildFoodNameField(context),
                  //_buildFoodDescField(context),
                  _progressBarActive == true? CommonStyles.loadingBar(context): _buildSubmitButton(context),

                  //_buildLoginOptionText(),
                  //_buildSocialLoginRow(context),
                ],
              ),
            ),
           // _buildSignUp(),
          ],
        ),
      );
  }

  modal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(child: Container(
            height: 600,
            margin: EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Search your location",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      if (predictions.length > 0 && mounted) {
                        setState(() {
                          predictions = [];
                        });
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(predictions[index].description ?? "No results found"),
                        onTap: () {
                          // debugPrint(predictions[index].placeId);
                          // debugPrint(predictions[index].structuredFormatting.toString());

                          getDetails(predictions[index].description ?? "", predictions[index].placeId?? "");
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ), );

        });
  }

  Widget draggableScrollSheet()
  {
    return DraggableScrollableSheet(
        builder: (BuildContext context, ScrollController scrollController)
    {
      return
        SafeArea(
        child:
        Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  labelText: "Search your location",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black54,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    autoCompleteSearch(value);
                  } else {
                    if (predictions.length > 0 && mounted) {
                      setState(() {
                        predictions = [];
                      });
                    }
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(predictions[index].description ?? "No results found"),
                      onTap: () {
                        // debugPrint(predictions[index].placeId);
                        // debugPrint(predictions[index].structuredFormatting.toString());

                        getDetails(predictions[index].description ?? "", predictions[index].placeId?? "");
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void autoCompleteSearch(String value) async {
    // print(value);

    var result = await googlePlace.autocomplete.get(value, offset:3, components: [Component("country", "UK")], region: "UK");

    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void getDetails(String desc, String placeId) async {
    var result = await googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {

      // print(result.result!.geometry!.location!.lat);
      // print(result.result!.geometry!.location!.lng);

      Navigator.pop(context, LocationDetailsModel(desc, result.result!.geometry!.location!.lat?? 0.0, result.result!.geometry!.location!.lng?? 0.0, placeId));
    }
  }

  Widget __buildTwitterButtonWidget(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: RaisedButton(
            color: const Color.fromRGBO(16, 161, 250, 1.0),
            child: Image.asset(
              "assets/images/ic_twitter.png",
              width: 25,
              height: 25,
            ),
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
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
    padding: CommonStyles.textFieldsPadding(),
    child: TextFormField(
        controller: _userPersonNameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        style: CommonStyles.textFormStyle(),
        /*onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },*/
        validator: (value) {
  if (value == null || value.isEmpty) {
  return "Please enter person name";
  }
  return null;
  },
        decoration: CommonStyles.textFormFieldDecoration("", "Person Name"),
      ),
    );
  }

  Widget _buildRestaurantName(BuildContext context) {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(
        controller: _userRestaurantNameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        style: CommonStyles.textFormStyle(),
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
    if (value == null || value.isEmpty) {
    return "Please enter business name";
    }
    return null;
        },
        decoration: CommonStyles.textFormFieldDecoration("", "Business/Entity Name"),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(
        showCursor: false,
        readOnly: true,
        controller: _userEmailController,
        style: CommonStyles.textFormStyle(),
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
        decoration: CommonStyles.textFormFieldDecoration("", "Email"),
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
        padding: CommonStyles.textFieldsPadding(),
      child: Row(
        children: [

          Flexible(
            child: Container(
              width:45,
              child: TextFormField(
                maxLength: 2,
                readOnly: true,
            showCursor: false,
            controller: _userContactNumbeCodeController,
                style: CommonStyles.textFormStyle(),
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
              FocusScope.of(context).requestFocus(_passwordFocusNode);
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

  Widget _buildAddressField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: Row(
        children: const [
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

  Widget _buildContactField(BuildContext context) {
    return
         Row(
          children: [
            CommonStyles.textFormNameField("Code"),
            CommonStyles.textFormNameField("Contact Number"),
          ],
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
        decoration: CommonStyles.textFormFieldStyle("City", ""),
      ),
    );
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
                return "Please enter your address";
              }
              return null;
            },
            decoration: CommonStyles.textFormFieldDecoration("", "Enter your Address"),
            onTap: () async {
               _awaitReturnValueFromPlacesAutocomplete(context);

              // draggableScrollSheet();

              //modal(context);

            }),
      );
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

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  Widget _buildStateNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(

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
        decoration: CommonStyles.textFormFieldStyle("State", ""),
      ),
    );
  }

  Widget _buildStatesAutoCompleteTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(

        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) {
          if (value == null || value.isEmpty)
          {
            return "Please enter valid street name";
          }
          return null;
        },
        decoration: CommonStyles.textFormFieldStyle("Street", ""),
      ),
    );
  }

  Widget _buildStreetNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(

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
        decoration: CommonStyles.textFormFieldStyle("Street", ""),
      ),
    );
  }

  Widget _buildPostalCodeField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(

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
        decoration: CommonStyles.textFormFieldStyle("Postal/Zip Code", ""),
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
            _donorProfileModel == null? "Submit" : "Update",
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Raleway'),
          ),
          onPressed: () {

            _signUpProcess(context);

            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => TestHomePage()));
          },
        ),
      ),
    );
  }

  void _signUpProcess(BuildContext context) {

    final form = _formKey.currentState;

      if (form!.validate()) {

      _donorProfileModel == null? donorRegistrationApiCall(context) : donorUpdateProfileApiCall(context);

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
      _userRestaurantNameController = TextEditingController(text: "");
      _userEmailController = TextEditingController(text: "");
      _userContactNumberController = TextEditingController(text: "");
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
        // "password": _userPersonNameController.value.text,
        "contact_number": _userContactNumberController.value.text,
        "code":_userContactNumbeCodeController.value.text,
        // "country": _userCountryNameController.value.text,
        // "area_name": _userAreaNameController.value.text,
        // "state_name": _userStateNameController.value.text,
        // "street_name": _userStreetNameController.value.text,
        // "postcode": _userPostalCodeController.value.text,
        "address": locationDetailsModel.address,
        "lat":locationDetailsModel.lat,
        "lng":locationDetailsModel.lng,
        "place_id":locationDetailsModel.placeId,
        "role":Constants.ROLE_DONOR,
        "firebase_token": fb_token
      };

    try
    {
      Future<FoodDonorRegistration> donorRegistrationResp = ApiService.donorRegistration(jsonEncode(body));
      donorRegistrationResp.then((value){
        setState(() {
          _progressBarActive = false;
        });
        // hideProgressDialog();

        if (!value.error)
          {
            if (value.message == "Inserted") {
              storeUserData(value.data.userId, value.data.name, value.data.businessName, value.data.email, value.data.contactNumber, value.data.role, value.data.address, value.data.lat, value.data.lng );
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  DonorDashboard()), (route) => false);

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

  void donorUpdateProfileApiCall(BuildContext context)
  {
    setState(() {
      _progressBarActive = true;
    });


    Map body =
    {
      "user_id": _donorProfileModel!.userId,
      "name": _userPersonNameController.value.text,
      "business_name": _userRestaurantNameController.value.text,
      "email": _userEmailController.value.text,
      "contact_number": _userContactNumberController.value.text,
      "code":_userContactNumbeCodeController.value.text,
      "address": locationDetailsModel.address,
      "lat":locationDetailsModel.lat,
      "lng":locationDetailsModel.lng,
      "place_id":locationDetailsModel.placeId,
      "role":Constants.ROLE_DONOR,
      "firebase_token": fb_token
    };

    // print(jsonEncode(body));

    try
    {
      Future<FoodDonorRegistration> donorRegistrationResp = ApiService.donorUpdateProfile(jsonEncode(body));
      donorRegistrationResp.then((value){
        setState(() {
          _progressBarActive = false;
        });
        // print(value.message);
        // print(value.data);
        // hideProgressDialog();

        if (!value.error)
        {
          if (value.message == "updated") {
            Constants.showToast(value.message);
            storeUserData(value.data.userId, value.data.name, value.data.businessName, value.data.email, value.data.contactNumber, value.data.role, value.data.address, value.data.lat, value.data.lng );
            Navigator.pop(context, true);
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

  void apiCall(BuildContext context)
  {

    try
    {
      Future<dynamic> donorRegistrationResp = ApiService.test();
      donorRegistrationResp.then((value){
        // print(value);

      });

    }
    on Exception catch(e)
    {
      Navigator.pop(context);
      // print(e);
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

  // void getCurrentLocation() async
  // {
  //   Location location = Location();
  //
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;
  //
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
  //
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //
  //   _locationData = await location.getLocation();
  //   print(_locationData.latitude);
  //   print(_locationData.longitude);
  // }


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

  }

// class DonorRegistrationScreen extends StatefulWidget {
//   String _email = "";
//   DonorRegistrationScreen(String email)
//   {
//     _email = email;
//   }
//
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _DonorRegistrationScreen(_email);
//   }
// }
//
// class _DonorRegistrationScreen extends State<DonorRegistrationScreen> {
//
//   String _email = "";
//
//   _DonorRegistrationScreen(String email)
//   {
//     _email = email;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Donor Registration"),
//         backgroundColor: Colors.blue,
//         elevation: 0.0,
//         titleSpacing: 10.0,
//         centerTitle: true,
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.45,
//                 width: double.infinity,
//                 child: CommonStyles.layoutBackgroundShape(),
//                 //decoration: BoxDecoration(color: ColorUtils.appBarBackgroundForSignUp),
//               ),
//               // const Align(
//               //     alignment: Alignment.topCenter,
//               //     child: Padding(
//               //       padding: EdgeInsets.only(top: 80),
//               //       child: Text(
//               //         "Closing Time!",
//               //         style: TextStyle(
//               //             color: Colors.white,
//               //             fontWeight: FontWeight.w800,
//               //             fontSize: 25),
//               //       ),
//               //     )),
//               Positioned(
//                 top: 140,
//                 left: 10,
//                 right: 10,
//                 child: LoginFormWidget(_email),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }