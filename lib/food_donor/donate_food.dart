import 'dart:convert';
import 'dart:typed_data';

import 'package:closingtime/food_donor/data_model/food_donated_list_data.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/CustomRaisedButtonStyle.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:closingtime/utils/google_places.dart';
import 'package:closingtime/utils/location_details_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DonateFood extends StatelessWidget
{

  var globalContext;

  Data? _addedFoodModel;
  DonateFood(Data? addedFoodModel)
  {
    _addedFoodModel = addedFoodModel;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
        appBar:AppBar(
          title: const Text("Food Donation"),
          backgroundColor: Colors.blue,
          elevation: 0.0,
          titleSpacing: 10.0,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),

        body:
        // Container(
        //   height: MediaQuery.of(context).size.height,
        //   child:
        Container(
            height: MediaQuery.of(context).size.height,
      child:
        DonateFoodFormWidget(_addedFoodModel),
              ),);
  }
}


class DonateFoodFormWidget extends StatefulWidget {

  Data? _addedFoodModel;
  DonateFoodFormWidget(Data? addedFoodModel)
  {
    this._addedFoodModel = addedFoodModel;
  }

  @override
  State<StatefulWidget> createState() {
    return _DonateFoodFormWidget(_addedFoodModel);
  }
}

class _DonateFoodFormWidget extends State<DonateFoodFormWidget> {

  Data? _addedFoodModel;
  _DonateFoodFormWidget(Data? addedFoodModel)
  {
    this._addedFoodModel = addedFoodModel;
  }

  final _formKey = GlobalKey<FormState>();
  var _foodNameController;
  var _foodDescController ;
  var _foodIngredientsInfoController;
  var _foodQuantityController;
  var _foodPickUpDateController;
  var _foodPickUpTimeController;
  var _ingredientsSearchController;
  var _userAddressFieldController;

  final _imagePicker = ImagePicker();
  final  picker = ImagePicker();
  bool _isListViewVisible = false;
  bool _autoValidate = false;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserAddress();


    _foodNameController = TextEditingController(text: _addedFoodModel == null? "" : _addedFoodModel!.foodName);
    _foodDescController = TextEditingController(text: _addedFoodModel == null? "" : _addedFoodModel!.foodDesc);
    _foodIngredientsInfoController = TextEditingController(text: _addedFoodModel == null? "" : _addedFoodModel!.foodIngredients);
    _foodQuantityController = TextEditingController(text: _addedFoodModel == null? "" : _addedFoodModel!.quantity);
    _foodPickUpDateController = TextEditingController(text: _addedFoodModel == null? "" : _addedFoodModel!.pickUpDate);
    _foodPickUpTimeController = TextEditingController(text: _addedFoodModel == null? "" : _addedFoodModel!.pickUpTime);
    _ingredientsSearchController = TextEditingController(text: "");

    _userAddressFieldController = TextEditingController(text: _addedFoodModel == null? _address : _addedFoodModel!.pickUpAddress);
    // print(_address);

    // foodAllergenList.addAll(_addedFoodModel.allergen);

    if (_addedFoodModel != null)
      {
        if(_addedFoodModel!.image.isNotEmpty)
          {
            setState(() {
              //_image = File();
              // _encodedString = _addedFoodModel!.image;
              _addedFoodModel!.image;
            }
            );
          }
      }
  }

  String? _address;
  late double? _lat, _lng;

  void getUserAddress() async
  {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _address = sp.getString(Constants.address);
    _lat = sp.getDouble(Constants.lat) ;
    _lng = sp.getDouble(Constants.lng) ;

    setState(() {
      _userAddressFieldController.text = _address;
    });

  }

  File _decodeFile(encodedString)
  {
    Uint8List bytes = base64Decode(encodedString);
    //dart_image.Image image = await compute<List<int>, dart_image.Image>(dart_image.decodeImage, byteArray);

    var file = File("");
    file.writeAsBytesSync(bytes);
    return file;
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: _autoValidate,
      key: _formKey,
      child:

      SingleChildScrollView(
        child: Container(
        child: Column(
        children: <Widget>[
          // _buildIntroText(),
          _buildImageCaptureField(context),
          CommonStyles.textFormNameField("Food Name"),
          _buildFoodNameField(context),
          const SizedBox(height: 30,),
          CommonStyles.textFormNameField("Food description (optional)"),
          _buildFoodDescField(context),
          const SizedBox(height: 30,),
          CommonStyles.textFormNameField("Select food allergens may contain (optional"),
          const SizedBox(height: 10,),
          _buildFoodIngredientsField(context),
          // _buildFoodAllergenAutoCompleteTextField(context),
          _buildFoodAllergenDropdown(context),
          const SizedBox(height: 30,),
          CommonStyles.textFormNameField("Additional information (optional)"),
          _buildFoodIngredientsInfoField(context),
          const SizedBox(height: 30,),
          CommonStyles.textFormNameField("Food quantity"),
          _buildFoodQuantityField(context),
          const SizedBox(height: 30,),
          CommonStyles.textFormNameField("Food pickup date"),
          _buildFoodPickUpDateField(context),
          const SizedBox(height: 30,),
          CommonStyles.textFormNameField("Food pickup time"),
          _buildFoodPickUpTimeField(context),
          const SizedBox(height: 30,),
          CommonStyles.textFormNameField("Food pickup address"),
          _buildChooseAddressField(context),
          _isLoading == true? CommonStyles.loadingBar(context):_buildSubmitButton(context),
        ],

    ),),),);
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
              child:
              Padding(
              padding: const EdgeInsets.only(top: 10),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: ColorUtils.primaryColor,
                  child: _encodedString.isNotEmpty
                      ? CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    Image.memory(
                      base64Decode(_encodedString),
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitHeight,
                    ).image,
                  ) : _addedFoodModel != null?
                  _addedFoodModel!.image.isNotEmpty?
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    NetworkImage(_addedFoodModel!.image,),
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
                  ): Container(
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
    XFile? file = await _imagePicker.pickImage(
        source: ImageSource.camera,
      imageQuality: 25
    );


    setState(() {
      if (file != null)
        {
          _image = File(file.path);

          final bytes = _image!.readAsBytesSync();
          //print(bytes);
          _encodedString = base64Encode(bytes);
        }

    });
  }


  Widget _buildFoodNameField(BuildContext context) {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(

        controller: _foodNameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        style: CommonStyles.textFormStyle(),
        onFieldSubmitted: (_) {
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter food item name";
          }
          return null;
        },
        decoration: CommonStyles.textFormFieldDecoration("", "eg. donuts"),
      ),
    );
  }


  Widget _buildFoodDescField(BuildContext context) {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(
        controller: _foodDescController,
        style: CommonStyles.textFormStyle(),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
        },
        validator: (value) {
        },
        decoration: CommonStyles.textFormFieldDecoration("", "eg. 6 pieces of fresh donuts, BB this weekend"),
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
          height: 55,
          child: ListView.builder(
            shrinkWrap:  true,
            scrollDirection: Axis.horizontal,
            itemCount: foodAllergenList.length,

            itemBuilder: (context,index){
              return Wrap(
                //color: Colors.grey,//selectedIndex==index?Colors.green:Colors.red,//now suppose selectedIndex and index from this builder is same then it will show the selected as green and others in red color
                children: [
                _itemCard(context, foodAllergenList.elementAt(index)),
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
                      foodAllergenList.remove(ingredient);

                      if (foodAllergenList.isEmpty)
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

  static const List<String> allergens = <String>[
    'Select',
    'Milk',
    'Eggs',
    'Fish',
    'Crustacean shellfish',
    'Tree nuts',
    'Peanuts',
    'Wheat',
    'Soybeans',
  ];

  Widget _buildFoodAllergenAutoCompleteTextField(BuildContext context) {
    return
      Padding(
        padding: CommonStyles.textFieldsPadding(),
        child: SearchField(
        controller: _ingredientsSearchController,
        suggestions: allergens,

        validator: (x) {
          // if (!ingredientsList.contains(x) || x!.isEmpty) {
          //   return 'Please Enter a valid State';
          // }
          return null;
        },
        searchInputDecoration: CommonStyles.textFormFieldStyle(" 🔍 Search food allergens may contain (optional)", ""),

        maxSuggestionsInViewPort: 6,
        itemHeight: 50,
        onTap: (x) {

          createIngredientsList(x);
          _ingredientsSearchController.clear();

        },
    ),);
  }

  String _dropDownValue = 'Select';

  Widget _buildFoodAllergenDropdown(BuildContext context) {
    return Padding(
        padding: CommonStyles.textFieldsPadding(),
        child: DropdownButton(
          hint: _dropDownValue == null
              ? Text('Select')
              : Text(
            _dropDownValue,
            style: TextStyle(color: Colors.black),
          ),
          isExpanded: true,
          iconSize: 30.0,
          style: const TextStyle(
            color: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 15,
              fontFamily: 'Raleway'
          ),
          items: allergens.map(
                (val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              );
            },
          ).toList(),
          onChanged: (val) {

            if (val.toString() == "Select")
              {
                return;
              }

            setState(
                  () {
                _dropDownValue = val.toString();

                createIngredientsList(_dropDownValue);

              },
            );
          },
        ),);
  }

  Set foodAllergenList = {};

  void createIngredientsList(item)
  {
    setState(() {
      foodAllergenList.add(item);
      _isListViewVisible = true;
      _dropDownValue = "Select";
    });
  }

  Widget _buildFoodIngredientsInfoField(BuildContext context) {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(
        controller: _foodIngredientsInfoController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        style: CommonStyles.textFormStyle(),
        onFieldSubmitted: (_) {
        },
        validator: (value) {
        },
        decoration: CommonStyles.textFormFieldDecoration("", "eg. It contains more sugar"),
      ),
    );
  }

  Widget _buildFoodQuantityField(BuildContext context) {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(
        controller: _foodQuantityController,
        keyboardType: TextInputType.text,
        style: CommonStyles.textFormStyle(),
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) {
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter the quantity";
          }
          return null;
        },
        decoration: CommonStyles.textFormFieldDecoration("", "eg. 2 pieces"),
      ),
    );
  }

  Widget _buildFoodPickUpDateField(BuildContext context) {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(
        showCursor: false,
        readOnly: true,
        controller: _foodPickUpDateController,
          style: CommonStyles.textFormStyle(),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) {
        },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select the pick up date";
            }
            return null;
          },
        decoration: CommonStyles.textFormFieldDecoration("", "YYYY-MM-DD"),
        onTap: (){
          _selectDate(context);
          }),
    );
  }

  Widget _buildFoodPickUpTimeField(BuildContext context) {
    return Padding(
      padding: CommonStyles.textFieldsPadding(),
      child: TextFormField(
        controller: _foodPickUpTimeController,
        keyboardType: TextInputType.text,
        style: CommonStyles.textFormStyle(),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter the pick up time";
          }
          return null;
        },
        decoration: CommonStyles.textFormFieldDecoration("", "eg. Tomorrow from 3 - 7pm "),
      ),
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
       if (pickedDate!.toString().isNotEmpty)
         {
           _foodPickUpDateController.text = myFormat.format(pickedDate!);
         }
      //_foodPickUpDateController.text = pickedDate.toString();
    });
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
                return "Please enter food pick up Address";
              }
              return null;
            },
            decoration: CommonStyles.textFormFieldDecoration("", "eg. 36 monster road, edison, NJ"),
            onTap: () async {
              _awaitReturnValueFromPlacesAutocomplete(context);

              // draggableScrollSheet();

              //modal(context);

            }),
      );
  }

  late LocationDetailsModel _locationDetailsModel;

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
        _locationDetailsModel = result;
        _userAddressFieldController.text = _locationDetailsModel.address;
        _lat = _locationDetailsModel.lat;
        _lng = _locationDetailsModel.lng;
      }
    });
  }


  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
        width: double.infinity,
        child: CustomRaisedButton(
          child:  Text(
            _addedFoodModel == null? "Donate" : "Update",
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            _formValidation();

            // getUserId(context);
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
    String business_name = sharedPreferences.getString(Constants.business_name) ?? '';

    if (_image == null)
    {
      if (_addedFoodModel != null)
      {
        if (_addedFoodModel!.image.isNotEmpty)
        {
          setState(() {
            _isLoading = true;
          });

          modifyFoodApiCall(context, userId, business_name, _addedFoodModel!.image);
        }
        else{
          Constants.showToast("Please upload the food image");
        }
      }
      else
      {
        Constants.showToast("Please upload the food image");
      }
    }
    else
    {
      setState(() {
        _isLoading = true;
      });

      uploadImageToFirebase(context, userId, business_name);
    }



    // if (_image == null)
    //   {
    //     addFoodApiCall(context, userId, business_name, "");
    //   }
    // else
    //   {
    //     uploadImageToFirebase(context, userId, business_name);
    //   }
  }

  String _encodedString = "";


  Future uploadImageToFirebase(BuildContext context, String userId, String business_name) async {
    // String fileName = _image!.path;
    var timestamp = DateTime. now(). millisecondsSinceEpoch;
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(Constants.prod + '/food_images/$userId' + '_$timestamp');
    UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
    await uploadTask.then(
          (value) {
            value.ref.getDownloadURL().then((url) {
              // print(url);

              if (_addedFoodModel != null)
                {
                  modifyFoodApiCall(context, userId, business_name, url);
                }
              else
                {
                  addFoodApiCall(context, userId, business_name, url);
                }

            }
            );
          }
    );
  }


  void addFoodApiCall(BuildContext context, userId, business_name, image)
  {
    // pd = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    // pd.style(message: "Loading");
    // pd.show();



    // if (_image != null)
    // {
    //   final bytes = _image!.readAsBytesSync();
    //   //print(bytes);
    //   _encodedString = base64Encode(bytes);
    // }

    //print(encodedString);


    Map body =
    {
      "user_id": userId,
      "food_name": _foodNameController.value.text,
      "food_desc": _foodDescController.value.text,
      "quantity": _foodQuantityController.value.text,
      "allergen": foodAllergenList.isEmpty? "": foodAllergenList.toString().replaceAll("{", "").replaceAll("}", ""),
      "pick_up_date": _foodPickUpDateController.value.text,
      "pick_up_time": _foodPickUpTimeController.value.text,
      "food_ingredients": _foodIngredientsInfoController.value.text,
      "pick_up_address": _userAddressFieldController.value.text,
      "pick_up_lat": _lat,
      "pick_up_lng": _lng,
      "image": image,
      "isFoodAccepted": false,
      "business_name": business_name,
      "status": Constants.STATUS_AVAILABLE,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };

    try
    {
      Future<dynamic> response = ApiService.addFood(jsonEncode(body));
      response.then((value){
        // print(value.toString());

        // hideProgressDialog();

        setState(() {
          _isLoading = false;
        });

        if (!value['error'])
        {
          if (value['message'] == "Inserted") {

            Constants.showToast(value['message']);

            Navigator.pop(context, true);

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
      // print(e);
      Constants.showToast('Please try again');
    }
  }

  void modifyFoodApiCall(BuildContext context, userId, business_name, image)
  {

    Map body =
    {
      "id":_addedFoodModel!.id,
      "user_id": userId,
      "food_name": _foodNameController.value.text,
      "food_desc": _foodDescController.value.text,
      "quantity": _foodQuantityController.value.text,
      "allergen": foodAllergenList.isEmpty? "": foodAllergenList.toString().replaceAll("{", "").replaceAll("}", ""),
      "pick_up_date": _foodPickUpDateController.value.text,
      "pick_up_time": _foodPickUpTimeController.value.text,
      "food_ingredients": _foodIngredientsInfoController.value.text,
      "image": image


      // "isFoodAccepted": false,
      // "business_name": business_name,
      // "status": Constants.STATUS_AVAILABLE,

      // "pick_up_address": _userAddressFieldController.value.text,
      // "pick_up_lat": _lat,
      // "pick_up_lng": _lng,

    };

    print(jsonEncode(body));

    try
    {
      Future<AddedFoodListModel> response = ApiService.modifyFoodItem(jsonEncode(body));
      response.then((value){
        // print(value.toString());

        // hideProgressDialog();

        setState(() {
          _isLoading = false;
        });

        if (!value.error)
        {
          if (value.message == Constants.updated) {

            Constants.showToast(value.message);

            Navigator.pop(context, value.data[0]);

          }
          else
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
      Constants.showToast('Please try again');
    }
  }
}


class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}


// class _DonateFood extends StatelessWidget {
//
//   Data? _addedFoodModel;
//   _DonateFood(Data? addedFoodModel)
//   {
//     this._addedFoodModel = addedFoodModel;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return
//       Scaffold(
//         appBar:AppBar(
//           title: const Text("Food Donation"),
//           backgroundColor: Colors.blue,
//           elevation: 0.0,
//           titleSpacing: 10.0,
//           centerTitle: true,
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(
//               Icons.arrow_back_ios,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           child: Stack(
//             children: <Widget>[
//               Container(
//
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
//                   top: 30,
//                   left: 10,
//                   right: 10,
//                   child: SingleChildScrollView(
//                     child:   DonateFoodFormWidget(_addedFoodModel),
//                   )
//               )
//             ],
//           ),
//         ),
//       );
//   }
// }