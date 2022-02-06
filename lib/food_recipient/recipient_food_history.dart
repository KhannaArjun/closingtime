import 'dart:convert';

import 'package:closingtime/food_donor/donor_food_description_screen.dart';
import 'package:closingtime/food_recipient/recipient_food_description_screen.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:closingtime/volunteer/volunteer_food_description_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:closingtime/food_donor/data_model/food_donated_list_data.dart';

class FoodRecipientHistory extends StatefulWidget {
  const FoodRecipientHistory({Key? key}) : super(key: key);

  @override
  _FoodDonorHistoryState createState() => _FoodDonorHistoryState();
}

class _FoodDonorHistoryState extends State<FoodRecipientHistory> {

  List<Data> _addedFoodList = [];

  @override
  void initState() {
    super.initState();

    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //forbidden swipe in iOS(my ThemeData(platform: TargetPlatform.iOS,)
      onWillPop: () async {
        if (Navigator
            .of(context)
            .userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEDED),
        appBar: AppBar(title: Text("History")),
        body: RefreshIndicator(
          onRefresh: getUserId,
          child:
          Center(
            child: getWidget(),

          ),
        ),
      ),);
  }

  String _userId = "";

  Future<void> getUserId() async
  {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userId = sharedPreferences.getString(Constants.user_id) ?? '';

    //await Future.delayed(const Duration(seconds: 3));

    _userId = userId;

    _getFoodHistory(userId);
  }

  Widget getWidget() {
    if (_isLoading == true) {
      return CommonStyles.loadingBar(context);
    }

    if (_isDataEmpty == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(child: const Text('No history found')),
          GestureDetector(
            onTap: () {
              getUserId();
            },
            child: Text("Refresh",
              style: TextStyle(color: ColorUtils.primaryColor, fontSize: 16),),
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

  Widget _itemCard(BuildContext context, Data addedFoodModel) {
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
            var result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FoodDescription(addedFoodModel, true)));
            if (result == true) {
              getUserId();
            }
          },
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: CircleAvatar(
                      backgroundImage: addedFoodModel.image.isEmpty
                          ? NetworkImage(
                          "https://source.unsplash.com/user/c_v_r/1600x900")
                          : NetworkImage(addedFoodModel.image),
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
                            child: Text('Qty: ${addedFoodModel.quantity}',
                              textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 2),
                            child: SizedBox(
                              child: Text(
                                'Pick up date ${addedFoodModel.pickUpDate}',
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

              const SizedBox(),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    addedFoodModel.status == Constants.delivered? Constants.delivered : Constants.expired,
                    style: TextStyle(
                      color: addedFoodModel.status == Constants.delivered? Colors.lightGreen: Colors.red,
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

  bool _isLoading = false,
      _isDataEmpty = false;

  void _getFoodHistory(userId)
  {

    Map body = {
      "user_id": userId
    };

    try
    {
      Future<AddedFoodListModel> addedFoodListModel = ApiService.getFoodHistoryByRecipeint(jsonEncode(body));
      addedFoodListModel.then((value){

        if (!value.error)
        {
          if (value.data.isNotEmpty)
          {
            setState(() {
              _addedFoodList = value.data.reversed.toList();
              _isDataEmpty = false;
              _isLoading = false;

            });
          }
          else
          {
            //Constants.showToast(Constants.empty);

            setState(() {
              _isLoading = false;
              _isDataEmpty = true;

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
}
