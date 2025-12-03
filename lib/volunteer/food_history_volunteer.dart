import 'dart:convert';

import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:closingtime/volunteer/volunteer_food_description_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_model/volunteer_food_list_response.dart';

class VolunteerFoodHistory extends StatefulWidget {
  const VolunteerFoodHistory({Key? key}) : super(key: key);

  @override
  _VolunteerFoodHistoryState createState() => _VolunteerFoodHistoryState();
}

class _VolunteerFoodHistoryState extends State<VolunteerFoodHistory> {

  List<Data> _addedFoodList = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //forbidden swipe in iOS(my ThemeData(platform: TargetPlatform.iOS,)
      onWillPop: ()async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: ColorUtils.volunteerSurface,
        appBar: AppBar(
          title: const Text("History"),
          backgroundColor: ColorUtils.volunteerPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: ColorUtils.volunteerGradient,
            ),
          ),
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
        body: RefreshIndicator(
          onRefresh:  getUserId,
          child:
          Center(
            child: getWidget(),

          ),
        ),
      ),);
  }

  @override
  void initState() {
    super.initState();

    getUserId();
  }

  String _userId = "";

  Future<void> getUserId() async
  {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userId = sharedPreferences.getString(Constants.user_id) ?? '';
    double lat = sharedPreferences.getDouble(Constants.lat) ?? 0.0;
    double lng = sharedPreferences.getDouble(Constants.lng) ?? 0.0;

    //await Future.delayed(const Duration(seconds: 3));

    _userId = userId;

    _getFoodHistory(userId, lat, lng);
  }

  Widget getWidget()
  {
    if (_isLoading == true)
    {
      return CommonStyles.loadingBar(context);
    }

    if(_isDataEmpty == true)
    {
      return Column (
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('No history found'),
          GestureDetector(
            onTap: () {

              getUserId();
            },
            child: const Text("Refresh", style: TextStyle(color: ColorUtils.volunteerPrimary, fontSize: 16),),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: ColorUtils.volunteerCardBg,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () async {
            var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => VolunteerFoodDescription(addedFoodModel, true)));
            if (result == true)
            {
              //getUserId();
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
                      backgroundColor: ColorUtils.volunteerPrimary,
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

              const SizedBox(),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (addedFoodModel.status == Constants.delivered
                          ? ColorUtils.volunteerSuccess
                          : ColorUtils.volunteerError)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      addedFoodModel.status == Constants.delivered
                          ? Constants.delivered
                          : Constants.expired,
                      style: TextStyle(
                        color: addedFoodModel.status == Constants.delivered
                            ? ColorUtils.volunteerSuccess
                            : ColorUtils.volunteerError,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _isLoading = false, _isDataEmpty = false;

  void _getFoodHistory(userId, lat, lng)
  async {

    Map body = {
      "user_id": userId,
      "volunteer_lat": lat,
      "volunteer_lng": lng
    };

    // print(jsonEncode(body));

    try
    {
      Future<VolunteerFoodListModel> addedFoodListModel = ApiService.getFoodHistoryByVolunteer(jsonEncode(body));
      addedFoodListModel.then((value){
        // print(value.data);

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
      }).catchError((onError)
      {
        setState(() {
          _isLoading = false;
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
}
