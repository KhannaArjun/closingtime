import 'dart:typed_data';

import 'package:closingtime/registration/sign_in.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:closingtime/food_donor/data_model/food_donated_list_data.dart';
import 'package:closingtime/food_donor/donate_food.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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


    getUserId();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
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
      onPressed: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonateFood()));
      },
      icon: Icon(Icons.add),
      label: Text("Donote Food"),
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
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text('Hello, Guest.',
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonateFood()));

              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                removeSharedPreferences();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));

              },
            ),
          ],
        ),
      ),
    ),);
  }

  Widget getWidget()
  {
    if (isLoading == true)
    {
      return CommonStyles.loadingBar(context);
    }

    if(isDataEmpty == true)
    {
      return Container(child: Text('List of donated foods will be shown here'));
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
    return Container(
        height: 150,
        child: Card(
            color: Colors.white,
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child:
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: CircleAvatar(
                  backgroundImage: addedFoodModel.image.isEmpty? NetworkImage("https://source.unsplash.com/user/c_v_r/1600x900"):Image.memory(base64Decode(addedFoodModel.image)).image,
                  radius: 40,
                  backgroundColor: ColorUtils.primaryColor,
                ),
                ),

                Container(
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          addedFoodModel.foodName

                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                          child: Container(
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.teal),
                            //     borderRadius: BorderRadius.all(Radius.circular(10))
                            // ),
                            child: Text('Qty: ${addedFoodModel.quantity}',textAlign: TextAlign.center,),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                          child: Container(
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.teal),
                            //     borderRadius: BorderRadius.all(Radius.circular(10))
                            // ),
                            child: Text(addedFoodModel.foodDesc,textAlign: TextAlign.center,),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 2),
                          child: Container(
                            width: 260,
                            child: Text('Pick up on ${addedFoodModel.pickUpDate}',style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 48, 48, 54)
                            ),),


                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
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

  Future<void> getUserId() async
  {
    setState(() {
      isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userId = sharedPreferences.getString(Constants.user_id) ?? '';

    //await Future.delayed(const Duration(seconds: 3));

    foodListApiCall(userId);
  }

  void foodListApiCall(userId)
  {

    Map body = {
      "user_id": userId
    };

    try
    {
      Future<AddedFoodListModel> addedFoodListModel = ApiService.addedFoodList(jsonEncode(body));
      addedFoodListModel.then((value){
        print(value.data);

       /* setState(() {
        });*/

        print(isLoading);
        print(isDataEmpty);
        if (!value.error)
        {
          if (value.data.isNotEmpty)
          {
            setState(() {
              _addedFoodList = value.data;
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
      print(e);
      Constants.showToast("Please try again");
    }

  }

  void removeSharedPreferences() async
  {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}
