import 'dart:typed_data';

import 'package:closingtime/food_donor/donor_food_description_screen.dart';
import 'package:closingtime/registration/sign_in.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/volunteer/data_model/volunteer_food_list_response.dart';
import 'package:closingtime/volunteer/food_history_volunteer.dart';
import 'package:closingtime/volunteer/volunteer_food_description_screen.dart';
import 'package:closingtime/volunteer/volunteer_profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';


class VolunteerDashboard extends StatefulWidget {
  const VolunteerDashboard({Key? key}) : super(key: key);


  @override
  _VolunteerDashboardState createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  static const appTitle = 'Volunteer Dashboard';

  List<Data> _addedFoodList = [];

  double _recipient_lat = 0.0, _recipient_lng = 0.0;


  @override
  void initState() {
    super.initState();
    // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    // fcmSubscribe(firebaseMessaging);

    configureNotifications(context);

    getUserId();
  }

  void fcmSubscribe(firebaseMessaging) {
    firebaseMessaging.subscribeToTopic(Constants.FB_FOOD_ADDED_TOPIC);
  }

  void fcmUnSubscribe(firebaseMessaging) {
    firebaseMessaging.unsubscribeFromTopic('TopicToListen');
  }

  bool isDataEmpty = false;
  bool isLoading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  }

  void configureNotifications(context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      SnackBar snackBar = SnackBar(
        content: const Text(
          "New food added by donor",
          style: TextStyle(
            fontFamily: 'Vazir',
            fontSize: 16.0,
          ),
        ),
        backgroundColor: ColorUtils.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45.0),
        ),
        elevation: 3.0,
        duration: const Duration(minutes: 5),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Refresh',
          onPressed: () {

            getUserId();
          },
        ),
      );
      _scaffoldKey.currentState!.showSnackBar(snackBar);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print("onMessageOpenedApp: $message");

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => VolunteerDashboard()));

    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  }

  String _username = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(//forbidden swipe in iOS(my ThemeData(platform: TargetPlatform.iOS,)
      onWillPop: ()async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child:
      MaterialApp(
        title: appTitle,
        home: Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFEEEDED),
          appBar: AppBar(title: const Text(appTitle)),
          body: RefreshIndicator(
            onRefresh:  getUserId,
            child:
            Center(
              child: getWidget(),

            ),),
          drawer: Drawer(
            // Add a ListView to the drawer.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [

                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                          },
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: ColorUtils.primaryColor,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              //   child: Icon(
                              //     Icons.camera_alt,
                              //     color: Colors.grey[800],
                              //     size: 50,
                              //
                              // ),
                              child: Image.asset('assets/images/user.png'),
                            ),
                          ),
                        ),),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children:  [
                            SizedBox(
                              height: 10,
                            ),
                            Text('Hello, ${_username}.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),

                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                ),
                ListTile(
                  title: const Text('My Profile'),
                  onTap: () {

                    //Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VolunteerProfile()));

                  },
                ),
                ListTile(
                  title: const Text('History'),
                  onTap: () {

                    //Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VolunteerFoodHistory()));

                  },
                ),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () {

                    if (_scaffoldKey.currentState!.isDrawerOpen) {
                      _scaffoldKey.currentState!.openEndDrawer();
                    }

                    _showLogoutAlertDialog();

                  },
                ),
              ],
            ),
          ),
        ),),);
  }

  Widget getWidget()
  {
    if (isLoading == true)
    {
      return CommonStyles.loadingBar(context);
    }

    if(isDataEmpty == true)
    {
      return Column (
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('List of donated foods will be shown here'),
          GestureDetector(
            onTap: () {

              getUserId();

            },
            child: const Text("Refresh", style: TextStyle(color: ColorUtils.primaryColor, fontSize: 16),),
          ),
        ],
      );
    }
    else {
      return _buildFoodList(_addedFoodList, context);
    }
  }

  Widget _buildFoodList(List<Data> list, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0x00000000)
      ),
      child: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: list.length,
          itemBuilder: (context, i) {

            Data addedFoodModel = list[i];
            return _itemCard(context, addedFoodModel);
          }),
    );
  }

  Widget _itemCard(BuildContext context, Data addedFoodModel)
  {
    return SizedBox(
      height: 140,
      child: Card(
        color: Colors.white,
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: InkWell(
          onTap: () async {

            var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => VolunteerFoodDescription(addedFoodModel, false)));
            if (result == true)
            {
              getUserId();
            }

          },
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: CircleAvatar(
                      backgroundImage: addedFoodModel.image.isEmpty? NetworkImage("https://source.unsplash.com/user/c_v_r/1600x900"):NetworkImage(addedFoodModel.image),
                      radius: 40,
                      backgroundColor: ColorUtils.primaryColor,
                    ),
                  ),

                  SizedBox(

                    height: 100,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                            child: Text(
                              addedFoodModel.foodName,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          ),

                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                              child: RichText(
                                text: TextSpan(
                                  children: [

                                    const WidgetSpan(
                                      child: Icon(Icons.location_pin, size: 18),
                                    ),

                                    TextSpan(
                                        text:  '${addedFoodModel.distance} mi',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black
                                        )
                                    ),

                                  ],
                                ),
                              )
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 2),
                            child: SizedBox(
                              child: Text('Pick up date ${addedFoodModel.pickUpDate}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 48, 48, 54)
                                ),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children:  [
                  Text(
                    addedFoodModel.status == Constants.waiting_for_pickup? "Available" : addedFoodModel.status,
                    style: const TextStyle(
                      color: Colors.lightGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),),

                  SizedBox(width: 8,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  File fetchImage(String encodedString)
  {
    Uint8List bytes = base64Decode(encodedString);
    //dart_image.Image image = await compute<List<int>, dart_image.Image>(dart_image.decodeImage, byteArray);

    var file = File("decodedBezkoder.png");
    file.writeAsBytesSync(bytes);
    return file;
  }

  String _userId = "";

  Future<void> getUserId() async
  {
    setState(() {
      isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userId = sharedPreferences.getString(Constants.user_id) ?? '';
    double user_lat = sharedPreferences.getDouble(Constants.lat) ?? 0.0;
    double user_lng = sharedPreferences.getDouble(Constants.lng) ?? 0.0;
    String name = sharedPreferences.getString(Constants.name) ?? "Guest";
    String serving_distance = sharedPreferences.getString(Constants.serving_distance) ?? '';

    setState(() {
      _username = name;
    });

    //await Future.delayed(const Duration(seconds: 3));

    _recipient_lat = user_lat;
    _recipient_lng = user_lng;

    _userId = userId;

    volunteerFoodListApiCall(userId, user_lat, user_lng, serving_distance);
  }

  void volunteerFoodListApiCall(userId, user_lat, user_lng, serving_distance)
  {

    Map body = {
      "isFoodAccepted":true,
      "volunteer_lat": user_lat,
      "volunteer_lng": user_lng,
      // "user_id": userId,
      "serving_distance": serving_distance
    };

    // print(jsonEncode(body));

    try
    {
      Future<VolunteerFoodListModel> addedFoodListModel = ApiService.getAvailableFoodListForVolunteer(jsonEncode(body));
      addedFoodListModel.then((value){
        // print(value.data);

        if (!value.error)
        {
          if (value.data.isNotEmpty)
          {
            setState(() {
              _addedFoodList = value.data.reversed.toList();
              isDataEmpty = false;
              isLoading = false;

            });
          }
          else
          {
            //Constants.showToast(Constants.empty);

            setState(() {
              isLoading = false;
              isDataEmpty = true;

            });

          }
        }
      });

    }
    on Exception catch(e)
    {
      // print(e);
      Constants.showToast("Please try again");
    }
  }


  Future<void> _showLogoutAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();

                logoutApiCall();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFoodConfirmationAlertDialog(message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Thanks for accepting and status of the food changed now'),
              ],
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();

                logoutApiCall();
              },
            ),
          ],
        );
      },
    );
  }

  void logoutApiCall()
  {
    setState(() {
      isLoading = true;
    });

    Map body = {
      "user_id": _userId,
    };

    try
    {
      Future<dynamic> response = ApiService.logout(jsonEncode(body));
      response.then((value){

        setState(() {
          isLoading = false;
        });

        if (value['message'] == Constants.success)
        {
          removeSharedPreferences();
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              LoginScreen()), (route) => false);
        }
        else
        {
          Constants.showToast("Please try again");

        }
      });

    }
    on Exception catch(e)
    {
      // print(e);
      Constants.showToast("Please try again");
    }

  }


  void removeSharedPreferences() async
  {
    SharedPreferences sp = await SharedPreferences.getInstance();
    for(String key in sp.getKeys()) {
      if(key != Constants.firebase_token) {
        sp.remove(key);
      }
    }
  }

}
