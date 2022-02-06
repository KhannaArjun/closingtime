
import 'dart:convert';
import 'dart:ffi';

import 'package:closingtime/utils/ColorUtils.dart';
import 'package:closingtime/utils/CommonStyles.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:closingtime/utils/food_desc_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_service.dart';
import 'data_model/volunteer_food_description_model.dart';
import 'data_model/volunteer_food_list_response.dart';

class VolunteerFoodDescription extends StatefulWidget
{

  late Data addedFoodModel;

  bool _visible;

  VolunteerFoodDescription(this.addedFoodModel, this._visible);

  @override
  _VolunteerFoodDescriptionState createState() => _VolunteerFoodDescriptionState(addedFoodModel, _visible);
}

class _VolunteerFoodDescriptionState extends State<VolunteerFoodDescription> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late Data addedFoodModel;
  bool isLoading = false, reload = false, _visible = false;
  late String _userId, status = "";
  VolunteerFoodDescriptionModelData? _volunteerFoodDescriptionModelData;

  _VolunteerFoodDescriptionState(this.addedFoodModel, this._visible);

  @override
  void initState() {
    super.initState();

    // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    String donorId  = addedFoodModel.userId;
    String recipientId = addedFoodModel.recipientUserId;

    status = addedFoodModel.status;

    getUserId(donorId, recipientId);
  }


  Future<void> getUserId(String donorId, String recipientId) async
  {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userId = sharedPreferences.getString(Constants.user_id) ?? '';

    _userId = userId;

    _getFoodItemDetails(donorId, recipientId);
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
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Food details",
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
                                  color: Colors.grey,
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
                                  child:  Text( '${addedFoodModel.businessName} is donating',textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
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
                                RichText(
                                  text: TextSpan(
                                    children: [

                                      WidgetSpan(
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
                                ),

                                Visibility(
                                  visible: _visible,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
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

              // Container(
              //   padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
              //   child: Text( addedFoodModel.foodDesc,
              //     textAlign: TextAlign.left,
              //     style: const TextStyle(
              //         fontSize: 15
              //     ),
              //   ),
              // ),
              //
              // const SizedBox(
              //   height: 15,
              // ),

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

                      child:Text(addedFoodModel.pickUpTime ?? "", overflow: TextOverflow.ellipsis,
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


              Card(
                margin: EdgeInsets.all(20),
                elevation: 10,
                child:
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        children: [

                          WidgetSpan(
                            child: Icon(Icons.location_pin,
                              size: 16,),
                          ),
                          TextSpan(
                            text:  'Your location',
                          ),

                        ],
                      ),),


                    getDottedText(),

                    Text(
                        '${addedFoodModel.distance} mi' ,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),),

                    getDottedText(),


                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        children: [

                        
                          TextSpan(
                            text:  'Donor',
                          ),

                        ],
                      ),
                    ),


                    getDottedText(),

                    Text(
                        '${_volunteerFoodDescriptionModelData == null?"" : _volunteerFoodDescriptionModelData!.distance} mi ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),

                    getDottedText(),

                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        children: [

                          TextSpan(
                            text:  'Recipient',
                          ),

                          WidgetSpan(
                            child: Icon(Icons.location_pin,
                              size: 16,),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15,),

                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        children: [

                          TextSpan(
                            text:  'Total ride is approx. ',
                          ),

                          TextSpan(
                            text: _volunteerFoodDescriptionModelData == null? "": '${double.parse(addedFoodModel.distance) + double.parse(_volunteerFoodDescriptionModelData!.distance)} mi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )
                          ),


                          TextSpan(
                            text:  ' distance',
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
              ),),),

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
                height: 10,
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(28, 5, 0, 2),
                    child: SizedBox(
                      child:Text('Pick up address', overflow: TextOverflow.ellipsis,style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),

                 buildDonorPickUpAddressDetails(),

                  const SizedBox(
                    height: 30,
                  ),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(28, 5, 0, 2),
                    child: SizedBox(
                      child:Text('Delivery address', overflow: TextOverflow.ellipsis,style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),

                  buildRecipientDropAddressDetails(),

                ],
              ),

              const SizedBox(
                height: 50,
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: status == Constants.waiting_for_pickup? ColorUtils.primaryColor : Colors.grey),
                onPressed: ()
                {
                  status == Constants.waiting_for_pickup? _collectFood(addedFoodModel.userId, addedFoodModel.recipientUserId, addedFoodModel.id) : {};
                },
                child: Text(
                  status == Constants.waiting_for_pickup? "Collect food" : status,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),),),),
      ],
      ),
    ),);
  }

  Widget getDottedText()
  {
    return
      Text(
          '⋮',
       style: TextStyle(
         fontSize: 15,
         fontWeight: FontWeight.bold
       ));
  }


  Widget buildDonorPickUpAddressDetails() =>
      Container(
    padding: EdgeInsets.symmetric(horizontal: 28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 10,
          child: Container(

            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.center,
              child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Donor Details",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),),

                  const SizedBox(height: 12,),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Name",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),

                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                    _volunteerFoodDescriptionModelData != null? _volunteerFoodDescriptionModelData!.donorName : "",
                      style: TextStyle(fontSize: 17),
                    ),),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Business Name",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),

                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      _volunteerFoodDescriptionModelData != null? _volunteerFoodDescriptionModelData!.donorBusinessName : "",
                      style: TextStyle(fontSize: 17),
                    ),),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Contact Number",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),

                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      _volunteerFoodDescriptionModelData != null? _volunteerFoodDescriptionModelData!.donorContactNumber : "",

                      style: TextStyle(fontSize: 17),
                    ),),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Address",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),

                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      _volunteerFoodDescriptionModelData != null? _volunteerFoodDescriptionModelData!.donorAddress : "",

                      style: TextStyle(fontSize: 17),
                    ),),

                ],
              ),
            ),), ),
      ],
    ),
  );

  Widget buildRecipientDropAddressDetails() => Container(
    padding: EdgeInsets.symmetric(horizontal: 28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 10,
          child: SizedBox(
            width: 500,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                      child: Text(
                        "Recipient Details",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),),),
                  const SizedBox(height: 12,),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Name",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),

                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      _volunteerFoodDescriptionModelData != null? _volunteerFoodDescriptionModelData!.recipientName : "",
                      style: TextStyle(fontSize: 17),
                    ),),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Business Name",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),

                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      _volunteerFoodDescriptionModelData != null? _volunteerFoodDescriptionModelData!.recipientBusinessName : "",
                      style: TextStyle(fontSize: 17),
                    ),),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Contact Number",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),

                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      _volunteerFoodDescriptionModelData != null? _volunteerFoodDescriptionModelData!.recipientContactNumber : "",

                      style: TextStyle(fontSize: 17),
                    ),),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                    child: Text(
                      "Address",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),),

                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      _volunteerFoodDescriptionModelData != null? _volunteerFoodDescriptionModelData!.recipientAddress : "",
                      style: TextStyle(fontSize: 17),
                    ),),

                ],
              ),
            ),), ),
      ],
    ),
  );

  void _getFoodItemDetails(donorUserId, recipientUserId)
  {
    setState(() {
      isLoading = true;
    });

    Map body = {
      "donor_user_id":donorUserId,
      "recipient_user_id":recipientUserId,
    };

    // print(jsonEncode(body));

    try
    {
      Future<VolunteerFoodDescriptionModel> response = ApiService.getFoodItemDetails(jsonEncode(body));
      response.then((obj){

        setState(() {
          isLoading = false;
        });

        if (!obj.error)
        {
          if (obj.message == Constants.success)
          {

            setState(() {
              _volunteerFoodDescriptionModelData = obj.data;

            });
          }
          else
          {
            Constants.showToast(obj.message);

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

  void _collectFood(donorUserId, recipientUserId, food_id)
  {
    setState(() {
      isLoading = true;
    });

    Map body = {
      "donor_user_id":donorUserId,
      "recipient_user_id":recipientUserId,
      "volunteer_user_id":_userId,
      "food_item_id": food_id
    };

    // print(jsonEncode(body));

    try
    {
      Future<dynamic> response = ApiService.collectFood(jsonEncode(body));
      response.then((obj){

        setState(() {
          isLoading = false;
        });

        if (!obj['error'])
        {
          if (obj['message'] == Constants.success)
          {
            reload = true;

            setState(() {
              status = Constants.pick_up_scheduled;
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
}
