
import 'dart:convert';

import 'package:closingtime/food_donor/data_model/food_donated_list_data.dart';
import 'package:closingtime/network/api_service.dart';
import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:closingtime/utils/food_desc_image_widget.dart';
import 'package:closingtime/utils/preview_food_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'donate_food.dart';

class DonorFoodDescription extends StatefulWidget
{

  late Data addedFoodModel;
  bool _visible;

  DonorFoodDescription(this.addedFoodModel, this._visible);

  @override
  _DonorFoodDescriptionState createState() => _DonorFoodDescriptionState(addedFoodModel, _visible);
}

class _DonorFoodDescriptionState extends State<DonorFoodDescription> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late Data addedFoodModel;
  bool isLoading = false, reload = false, _visible = false;
  late String _userId, status = "";


  _DonorFoodDescriptionState(this.addedFoodModel, this._visible);

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
        child: Scaffold(
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
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: ColorUtils.primaryColor,
              ),
            ),

            actions: [
              Visibility(
                visible: !addedFoodModel.isFoodAccepted,
          child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,color: ColorUtils.primaryColor),
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Edit', 'Delete'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),),
            ],
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
                              ),),

                            SizedBox(
                              height: 120,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                      child:  Text( 'You are donating',textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
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
                    height: 5,
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
                    height: 20,
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
                          child:Text( addedFoodModel.foodIngredients.isEmpty? "Not available": addedFoodModel.foodIngredients, overflow: TextOverflow.ellipsis,style:
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
                          child:Text( addedFoodModel.allergen.isEmpty? "Not available": addedFoodModel.allergen, overflow: TextOverflow.ellipsis,style:
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
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 70),
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
                    height: 10,
                  ),
                ],
              ),
            ),

            Visibility(
              visible: !_visible,
              child: Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 45,
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                  child:
                  Visibility (
                    visible: status == Constants.STATUS_AVAILABLE? false:true ,
                    child : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: status == Constants.waiting_for_pickup? Colors.grey: status == Constants.pick_up_scheduled? ColorUtils.primaryColor : Colors.grey),
                      onPressed: () {

                      },
                      child: Text(
                        addedFoodModel.status,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ),
                      ),
                    ),),
                ),),),),
          ],

          ),
        ),
      onWillPop: ()async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
          );
  }

  void handleClick(String value) async {
    switch (value) {
      case 'Edit':
        Data? result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DonateFood(addedFoodModel)));

        if (result != null)
          {
            reload = true;

            setState(() {

              addedFoodModel = result;

            });
          }

        break;
      case 'Delete':
        _showDeleteAlertDialog();
        break;
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
          reload = true;
          Navigator.pop(context, reload);
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

  Future<void> _showDeleteAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to delete this food item?'),
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
                deleteAFoodItemApiCall(addedFoodModel.id);
              },
            ),
          ],
        );
      },
    );
  }

}
