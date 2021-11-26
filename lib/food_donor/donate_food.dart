import 'dart:convert';

import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:intl/intl.dart';

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
                top: 160,
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
  var _foodAllergenInfoController = TextEditingController(text: "Sugar, Apple cider");
  var _foodQuantityController = TextEditingController(text: "18 units");
  var _foodPickUpDateController = TextEditingController(text: "13-11-2021");
  var _ingredientsSearchController = TextEditingController(text: "");

  final _imagePicker = ImagePicker();
  final  picker = ImagePicker();
  bool _isListViewVisible = false;
  bool _autoValidate = false;
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: _autoValidate,
      key: _formKey,
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Column(
              children: <Widget>[
                _buildIntroText(),
                _buildImageCaptureField(context),
                _buildFoodNameField(context),
                _buildFoodDescField(context),
                _buildFoodIngredientsField(context),
                _buildFoodIngredientsAutoCompleteTextField(context),
                _buildFoodAllergenInfoField(context),
                _buildFoodQuantityField(context),
                _buildFoodPickUpDateField(context),
                _isLoading == true? CommonStyles.loadingBar(context):_buildSubmitButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildIntroText() {
    return Column(
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 30),
          child: Text(
            "Food Donation",
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

  File? _image;


  Widget _buildImageCaptureField(BuildContext context) {
    return  Stack(
      children: <Widget>[
         Center(
          child:  Center(
            child: GestureDetector(
              onTap: () {
                getImageFromCamera();
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: ColorUtils.primaryColor,
                child: _image != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    _image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50)),
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                    size: 50,
                  ),
                ),
              ),
            ),
          )
         ),
        //  Center(
        //   child: Image.asset("assets/images/photo_camera.png"),
        // ),
      ],
    );
  }


  void getImageFromCamera() async
  {
    XFile? file = await _imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(file!.path);

    });

  }


  Widget _buildFoodNameField(BuildContext context) {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
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
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(
        controller: _foodDescController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
        },
        validator: (value) {
        },
        decoration: CommonStyles.textFormFieldStyle("Food Description (optional)", ""),
      ),
    );
  }



  Widget _buildFoodIngredientsField(BuildContext context) {
    return Visibility(
      visible: _isListViewVisible,
        child: Padding(
          padding: CommonStyles.textFieldsPadding(),
          child: SizedBox(
        width: double.infinity,
          height: 65,
          child: ListView.builder(
            shrinkWrap:  true,
            scrollDirection: Axis.horizontal,
            itemCount: ingredientsList.length,
            itemBuilder: (context,index){
              return Wrap(
                //color: Colors.grey,//selectedIndex==index?Colors.green:Colors.red,//now suppose selectedIndex and index from this builder is same then it will show the selected as green and others in red color
                children: [
                _itemCard(context, ingredientsList.elementAt(index)),
                ],
              );
            },
          )
      ),
    ),);
  }

  Widget _itemCard(BuildContext context, String ingredient)
  {
    return Container(
      alignment: Alignment.center,
      height: 50,
      child: Card(
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child:
        Padding(
          padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  ingredient
              ),
              Container(

                child:  IconButton(
                  iconSize: 20,
                  color: Colors.red,
                  icon: const Icon(Icons.clear),
                  tooltip: 'remove ingredient',
                  onPressed: () {
                    setState(() {
                      ingredientsList.remove(ingredient);

                      if (ingredientsList.isEmpty)
                        {
                          _isListViewVisible = false;
                        }


                    });
                  },
              ),

              ),],
          ),

        ),
      ),
    );

  }

  static const List<String> _kOptions = <String>[
    'Sugar',
    'Apple',
    'cider',
    'Vinegar',
  ];

  Widget _buildFoodIngredientsAutoCompleteTextField(BuildContext context) {
    return
      Padding(
        padding: CommonStyles.textFieldsPadding(),
        child: SearchField(
        controller: _ingredientsSearchController,
        suggestions: _kOptions,

        validator: (x) {
          // if (!ingredientsList.contains(x) || x!.isEmpty) {
          //   return 'Please Enter a valid State';
          // }
          return null;
        },
        searchInputDecoration: CommonStyles.textFormFieldStyle(" 🔍 Search ingredients may contain (optional)", ""),

        maxSuggestionsInViewPort: 6,
        itemHeight: 50,
        onTap: (x) {

          createIngredientsList(x);
          _ingredientsSearchController.clear();

        },
    ),);
  }



  Set ingredientsList = {};

  void createIngredientsList(item)
  {
    setState(() {
      ingredientsList.add(item);
      _isListViewVisible = true;
    });
  }

  Widget _buildFoodAllergenInfoField(BuildContext context) {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(
        controller: _foodAllergenInfoController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
        },
        validator: (value) {
        },
        decoration: CommonStyles.textFormFieldStyle("Food Allergen Information (optional)", ""),
      ),
    );
  }

  Widget _buildFoodQuantityField(BuildContext context) {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
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
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(
        controller: _foodPickUpDateController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
        },
        validator: (value) {
        },
        decoration: CommonStyles.textFormFieldStyle("Food Pickup Date", ""),
        onTap: (){
          _selectDate(context);
          }),
    );
  }

  var myFormat = DateFormat('yyyy-MM-dd');

  _selectDate(BuildContext context) {
     showDatePicker(
      context: context,
       initialDate: DateTime.now(),
       firstDate: DateTime.now().subtract(Duration(days: 0)),
       lastDate: DateTime.now().add(Duration(days:7))

    ).then((pickedDate) {
      //do whatever you want
       _foodPickUpDateController.text = myFormat.format(pickedDate);
      //_foodPickUpDateController.text = pickedDate.toString();
    });
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: CustomRaisedButton(
          child: const Text(
            "Donate",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            _formValidation();

            //getUserId(context);
          },
        ),
      ),
    );
  }

  void _openCamera(BuildContext context) async {
    final capturedImage =
    await _imagePicker.pickImage(source: ImageSource.camera);

    if (capturedImage == null) {
      return;
    }

    Fluttertoast.showToast(msg: 'captured', toastLength: Toast.LENGTH_LONG);

    if (capturedImage.path == null) {
      Fluttertoast.showToast(msg: 'Null', toastLength: Toast.LENGTH_LONG);
    } else {
      Fluttertoast.showToast(msg: 'Routing', toastLength: Toast.LENGTH_LONG);
      //_performTextRecognition(capturedImage.path, context);

    }
  }

  void _formValidation()
  {

    final form = _formKey.currentState;

    if (form!.validate()) {

      getUserId(context);

    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }


  void getUserId(context) async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userId = sharedPreferences.getString(Constants.user_id) ?? '';

    addFoodApiCall(context, userId);
  }

  void addFoodApiCall(BuildContext context, userId)
  {
    // pd = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    // pd.style(message: "Loading");
    // pd.show();

    setState(() {
      _isLoading = true;
    });

    String encodedString = "";

    if (_image != null)
    {
      final bytes = _image!.readAsBytesSync();
      //print(bytes);
      encodedString = base64Encode(bytes);
    }

    //print(encodedString);


    Map body =
    {
      "user_id": userId,
      "food_name": _foodNameController.value.text,
      "food_desc": _foodDescController.value.text,
      "quantity": _foodQuantityController.value.text,
      "food_ingredients": ingredientsList.isEmpty? "": ingredientsList.toString(),
      "pick_up_date": _foodPickUpDateController.value.text,
      "allergen": _foodAllergenInfoController.value.text,
      "image": encodedString
    };

    try
    {
      Future<dynamic> response = ApiService.addFood(jsonEncode(body));
      response.then((value){
        print(value.toString());

        // hideProgressDialog();

        setState(() {
          _isLoading = false;
        });

        if (!value['error'])
        {
          if (value['message'] == "Inserted") {

            Constants.showToast(value['message']);

          }
          else
          {
            Constants.showToast(value['message']);
          }

        }
        else
        {
          Constants.showToast(value['message']);
        }

      });

    }
    on Exception catch(e)
    {
      print(e);
      Constants.showToast('Please try again');
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}