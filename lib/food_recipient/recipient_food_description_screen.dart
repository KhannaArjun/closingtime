
import 'dart:convert';

import 'package:closingtime/food_donor/data_model/food_donated_list_data.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:closingtime/utils/food_desc_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_service.dart';

class FoodDescription extends StatefulWidget
{

  late Data addedFoodModel;
  bool _visible;

  FoodDescription(this.addedFoodModel,this._visible);

  @override
  _FoodDescriptionState createState() => _FoodDescriptionState(addedFoodModel, _visible);
}

class _FoodDescriptionState extends State<FoodDescription> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late Data addedFoodModel;
  bool isLoading = false, reload = false, _visible = false;
  late String _userId, status = "";

  _FoodDescriptionState(this.addedFoodModel, this._visible);

  @override
  void initState() {
    super.initState();

    // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    getUserId();
  }


  Future<void> getUserId() async
  {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userId = sharedPreferences.getString(Constants.user_id) ?? '';

    setState(() {
      status = addedFoodModel.status;
    });

    _userId = userId;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
        child:
        Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
    title: const Text(
      "Food Description",
    style: TextStyle(
      color: ColorUtils.primaryColor
    ),),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleSpacing: 10.0,
    centerTitle: true,
    leading: InkWell(
    onTap: () {
    Navigator.pop(context, reload);
    },
    child: const Icon(
    Icons.arrow_back_ios,
    color: ColorUtils.primaryColor,
    ),
    ),
    ),
      body:
        isLoading == true? Align(
          alignment: Alignment.center,
          child: CommonStyles.loadingBar(context),
        ) :
        Stack(children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [

                  FoodDescImageWidget(addedFoodModel.image),


                  const SizedBox(
                    height: 20,
                  ),

                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Padding(padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                              child: CircleAvatar(
                                radius: 38,
                                backgroundColor: ColorUtils.primaryColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(60)),
                                  width: 70,
                                  height: 70,
                                  child: Image.asset('assets/images/user.png'),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 120,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                      child:  Text( '${addedFoodModel.business_name} is donating',textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                      child: Text(
                                        addedFoodModel.foodName,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                      child: Text(
                                        'Qty: ${addedFoodModel.quantity}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),

                                    Visibility(
                                      visible: _visible,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                        child: Text(
                                          addedFoodModel.status == Constants.delivered? Constants.delivered : Constants.expired,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: addedFoodModel.status == Constants.delivered? Colors.green : Colors.red,
                                          ),
                                        ),
                                      ),),
                                  ],
                                ),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                    child: Text( addedFoodModel.foodDesc,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 15
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 2),
                        child: SizedBox(
                          child:Text('Pick up date', overflow: TextOverflow.ellipsis,style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 48, 48, 54)
                          ),),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 2),
                        child: SizedBox(

                          child:Text(addedFoodModel.pickUpDate, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 2),
                        child: SizedBox(
                          child:Text('Pick up time', overflow: TextOverflow.ellipsis,style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 48, 48, 54)
                          ),),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 2),
                        child: SizedBox(

                          child:Text(addedFoodModel.pickUpTime == null? "": addedFoodModel.pickUpTime, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 2),
                        child: SizedBox(
                          child:Text('Pick up address', overflow: TextOverflow.ellipsis,style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 48, 48, 54)
                          ),),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 2),
                        child: SizedBox(

                          child:Text(addedFoodModel.pickUpAddress, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Column (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 2),
                        child: SizedBox(
                          child:Text('Ingredients Information', overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 2),
                        child: SizedBox(
                          width: 260,
                          child:Text( addedFoodModel.foodIngredients.isEmpty? "Not available": addedFoodModel.pickUpDate, overflow: TextOverflow.ellipsis,style:
                          const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 48, 48, 54)
                          ),),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Column (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 2),
                        child: SizedBox(
                          child:Text('Allergen Information', overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 2),
                        child: SizedBox(
                          width: 260,
                          child:Text( addedFoodModel.allergen.isEmpty? "Not available": addedFoodModel.pickUpDate, overflow: TextOverflow.ellipsis,style:
                          const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 48, 48, 54)
                          ),),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Container (
                    color: Colors.grey[200],
                    child:  const Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 0, 2),
                      child: Align(
                        alignment: Alignment.center,
                        child:Text("This food is for free 😊 \nStrictly no selling \n", overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 70),
                    child:   Stack(
                      children: [

                        Align(
                          alignment: Alignment.center,
                          child:  Image.asset(
                              "assets/images/map.jpeg",
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.fitWidth
                          ),
                        ),

                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                            child: const Icon(
                              Icons.location_pin,
                              size: 54,
                              color: Colors.red,
                            ),),
                        ),

                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                "Approx. ${addedFoodModel.distance} mi away",
                                style: TextStyle(
                                    color: Colors.black
                                ),
                              ),),),
                        ),

                      ],
                    ),
                  ),
                ],
              ),),


           Visibility(
             visible: !_visible,
             child: Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 45,
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    primary: status == Constants.STATUS_AVAILABLE? ColorUtils.primaryColor
                        : status == Constants.waiting_for_pickup? Colors.grey: status == Constants.pick_up_scheduled? ColorUtils.primaryColor : Colors.grey),
                    onPressed: () {
                      status == Constants.STATUS_AVAILABLE? acceptFoodApiCall(addedFoodModel.userId, _userId, addedFoodModel.id, addedFoodModel.business_name)
                          : status == Constants.pick_up_scheduled? foodDeliveredApiCall(addedFoodModel.userId, _userId, addedFoodModel.id, addedFoodModel.business_name) : {};
                    },
                    child: Text(
                      _buttonText(status),
                       style: const TextStyle(
                       fontSize: 18,
                       color: Colors.white,
    ),),
                  ),
                ),),),),
          ],
          ),
    ),);
  }

  String _buttonText(status)
  {
    if (status == Constants.STATUS_AVAILABLE)
    {
      return "Accept food";
    }
    else if (status == Constants.waiting_for_pickup) {
      return Constants.waiting_for_pickup;
    }
    else if (status == Constants.pick_up_scheduled) {
      return "Confirm food delivery";
    }
    else
      {
        return "Delivered";
      }
  }


  TextStyle _buttonTextStyle(status)
  {

    if (status == Constants.STATUS_AVAILABLE)
    {
      return const TextStyle(
        fontSize: 18,
        color:  Colors.white,
      );
    }
    else if (status == Constants.waiting_for_pickup) {
      return const TextStyle(
        fontSize: 18,
        color: Colors.black,
      );
    }
    else {
      return const TextStyle(
        fontSize: 18,
        color: Colors.white,
      );
    }
  }

  String _buttonTextColor(status)
  {
    if (status == Constants.STATUS_AVAILABLE)
    {
      return "Accept food";
    }
    else if (status == Constants.waiting_for_pickup) {
      return "Waiting for pick up";
    }
    else {
      return "yes, food delivered";
    }
  }

  void acceptFoodApiCall(donorUserId, recipientUserId, food_id, business_name)
  {
    setState(() {
      isLoading = true;
    });

    Map body = {
      "donor_user_id":donorUserId,
      "recipient_user_id":recipientUserId,
      "food_item_id": food_id,
      "business_name": business_name
    };

    // print(jsonEncode(body));

    try
    {
      Future<dynamic> response = ApiService.accept_food(jsonEncode(body));
      response.then((obj){
        //print(value.data);

        setState(() {
          isLoading = false;
        });

        if (!obj["error"])
        {
          if (obj['message'] == Constants.success)
          {
            reload = true;

            setState(() {
              status = Constants.waiting_for_pickup;

            });
          }
          else
          {
            Constants.showToast(obj['message']);

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

  void foodDeliveredApiCall(donorUserId, recipientUserId, food_id, business_name)
  {
    setState(() {
      isLoading = true;
    });

    Map body = {
      // "donor_user_id":donorUserId,
      // "recipient_user_id":recipientUserId,
      // "volunteer_user_id": ,
      "food_item_id": food_id,
      // "business_name": business_name
    };

    try
    {
      Future<dynamic> response = ApiService.foodDelivered(jsonEncode(body));
      response.then((obj){

        setState(() {
          isLoading = false;
        });

        if (!obj["error"])
        {
          if (obj['message'] == Constants.success)
          {
            reload = true;

            Constants.showToast("Thanks for the confirmation");

            // setState(() {
            //   status = Constants.delivered;
            //
            // });

            Navigator.pop(context, true);
          }
          else
          {
            Constants.showToast(obj['message']);

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
