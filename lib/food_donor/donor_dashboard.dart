
import 'package:closingtime/food_donor/donor_food_description_screen.dart';
import 'package:closingtime/food_donor/food_donor_history.dart';
import 'package:closingtime/registration/sign_in.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

import 'package:closingtime/food_donor/data_model/food_donated_list_data.dart';
import 'package:closingtime/food_donor/donate_food.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'donor_profile.dart';


class DonorDashboard extends StatefulWidget {
  const DonorDashboard({Key? key}) : super(key: key);


  @override
  _DonorDashboardState createState() => _DonorDashboardState();
}

class _DonorDashboardState extends State<DonorDashboard> {
  static const appTitle = 'Donor Dashboard';

  List<Data> _addedFoodList = [];

  @override
  void initState() {
    super.initState();
    // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    // fcmSubscribe(firebaseMessaging);

    configureNotifications(context);

    checkVersion(context);

    getUserId();
  }

  void checkVersion(context)async{
    final newVersion= NewVersion();

    // final status=await newVersion.getVersionStatus();

    // print(status?.localVersion);
    // print(status?.storeVersion);

    // print(status?.canUpdate);

    newVersion.showAlertIfNecessary(context: context);
  }

  void fcmSubscribe(firebaseMessaging) {
    firebaseMessaging.subscribeToTopic(Constants.FB_FOOD_ADDED_TOPIC);
  }

  void fcmUnSubscribe(firebaseMessaging) {
    firebaseMessaging.unsubscribeFromTopic('TopicToListen');
  }

  List<Data> setData(List<Data> data)
  {
    // List<FoodDonatedData> foodDonatedList = [];
    //
    // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    // foodDonatedList.add(FoodDonatedData("Donuts", "Fresh Donuts", "4", ""));
    //

    return data;

  }

  bool isDataEmpty = false;
  bool isLoading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message");
  }

  void configureNotifications(context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      // print(notification!.title);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print("onMessageOpenedApp: $message");

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonorDashboard()));

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

      floatingActionButton: Container(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton.extended(
      onPressed: () async {
      var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonateFood(null)));
      if (result == true)
        {
          getUserId();
        }
      },
      icon: const Icon(Icons.add),
      label: const Text("Donate Food"),
      ),
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                      Text('Hello, $_username.',
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonorProfile()));

              },
            ),
            ListTile(
              title: const Text('Donate Food'),
              onTap: () {

                //Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonateFood(null)));

              },
            ),

            ListTile(
              title: const Text('History'),
              onTap: () {

                //Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => FoodDonorHistory()));

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
          Container(child: Text('List of donated foods will be shown here')),
          GestureDetector(
            onTap: () {

              getUserId();

            },
            child: Text("Refresh", style: TextStyle(color: ColorUtils.primaryColor, fontSize: 16),),
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
              var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonorFoodDescription(addedFoodModel, false)));
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
                                padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                child: Text('Qty: ${addedFoodModel.quantity}',textAlign: TextAlign.center,),
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

                  addedFoodModel.status == "Available"?
                  const SizedBox() :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                        Text(
                        addedFoodModel.status,
                        style: const TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),

                          const SizedBox(width: 8,),
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
    String name = sharedPreferences.getString(Constants.name) ?? 'Guest';

    setState(() {
      _username = name;
    });

    //await Future.delayed(const Duration(seconds: 3));

    _userId = userId;

    foodListApiCall(userId);
  }

  void foodListApiCall(userId)
  {

    Map body = {
      "user_id": userId
    };


    print(jsonEncode(body));

    try
    {
      Future<AddedFoodListModel> addedFoodListModel = ApiService.addedFoodList(jsonEncode(body));
      addedFoodListModel.then((value){
        print(value.data);

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
      }).catchError((onError)
      {

        print(onError);
        setState(() {
          isLoading = false;
        });
        Constants.showToast(Constants.something_went_wrong);
      }
      );

    }
    on Exception {
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
      }).catchError((onError)
      {
        setState(() {
          isLoading = false;
        });
        Constants.showToast(Constants.something_went_wrong);
      }
      );
    }
    on Exception {
      // print(e);
      Constants.showToast("Please try again");
    }

  }

  void deleteAFoodItemApiCall(id)
  {

    Map body = {
      "user_id": _userId,
      "id": id
    };

    try
    {
      Future<dynamic> addedFoodListModel = ApiService.removeFoodItemList(jsonEncode(body));
      addedFoodListModel.then((value){

        setState(() {
          isLoading = false;
        });

        if (value['message'] == "deleted")
        {
          getUserId();
        }
        else
          {

            Constants.showToast("Please try again");

          }
      }).catchError((onError)
      {
        setState(() {
          isLoading = false;
        });
        Constants.showToast(Constants.something_went_wrong);
      }
      );

    }
    on Exception {
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
