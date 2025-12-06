
import 'dart:convert';

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

  final bool _visible;

  VolunteerFoodDescription(this.addedFoodModel, this._visible, {Key? key}) : super(key: key);

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
    String? recipientId = null;

    status = addedFoodModel.status;
    
    print("=== Food Description Debug ===");
    print("Current status: $status");
    print("_visible parameter: $_visible");
    print("Button should be visible: ${!_visible}");
    print("Button enabled for status: ${status == Constants.waiting_for_pickup || status == Constants.pick_up_scheduled}");
    print("Button text: ${_getButtonText(status)}");

    getUserId(donorId, null);
  }


  Future<void> getUserId(String donorId, String? recipientId) async
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
      backgroundColor: ColorUtils.volunteerSurface,
      appBar: AppBar(
        title: const Text(
          "Food details",
          style: TextStyle(
              color: Colors.white
          ),),
        backgroundColor: ColorUtils.volunteerPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 10.0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: ColorUtils.volunteerGradient,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context, reload);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
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

              // Food Details Section - Only show if there's data
              if (addedFoodModel.foodDesc.isNotEmpty || 
                  addedFoodModel.foodIngredients.isNotEmpty || 
                  addedFoodModel.allergen.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorUtils.volunteerCardBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food Description
                      if (addedFoodModel.foodDesc.isNotEmpty) ...[
                        const Text(
                          'Food Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.volunteerTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          addedFoodModel.foodDesc,
                          style: const TextStyle(
                            fontSize: 14,
                            color: ColorUtils.volunteerTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Food Ingredients
                      if (addedFoodModel.foodIngredients.isNotEmpty) ...[
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.volunteerTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          addedFoodModel.foodIngredients,
                          style: const TextStyle(
                            fontSize: 14,
                            color: ColorUtils.volunteerTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Allergens
                      if (addedFoodModel.allergen.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: ColorUtils.volunteerWarning,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Allergens',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorUtils.volunteerTextPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          addedFoodModel.allergen,
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorUtils.volunteerWarning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Food Header: Name, Business, Distance, Status
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorUtils.volunteerCardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Business Name
                    Text(
                      addedFoodModel.businessName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorUtils.volunteerTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Food Name
                    Text(
                      addedFoodModel.foodName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.volunteerTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Distance and Status
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 18,
                          color: ColorUtils.volunteerSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${addedFoodModel.distance} mi away',
                          style: const TextStyle(
                            fontSize: 14,
                            color: ColorUtils.volunteerTextSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        
                        // Status badge (if visible)
                        if (_visible)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: (addedFoodModel.status == Constants.delivered
                                  ? ColorUtils.volunteerSuccess
                                  : ColorUtils.volunteerError).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              addedFoodModel.status == Constants.delivered 
                                  ? Constants.delivered 
                                  : Constants.expired,
                              style: TextStyle(
                                fontSize: 12,
                                color: addedFoodModel.status == Constants.delivered
                                    ? ColorUtils.volunteerSuccess
                                    : ColorUtils.volunteerError,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Pickup Date & Time
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorUtils.volunteerCardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Pickup Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: ColorUtils.volunteerSecondary,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Pickup Date',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorUtils.volunteerTextSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            addedFoodModel.pickUpDate,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.volunteerTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 20),
                    
                    // Pickup Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: ColorUtils.volunteerSecondary,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Pickup Time',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorUtils.volunteerTextSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            addedFoodModel.pickUpTime.isNotEmpty 
                                ? addedFoodModel.pickUpTime 
                                : "Not specified",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.volunteerTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorUtils.volunteerSuccess.withValues(alpha: 0.1),
                      ColorUtils.volunteerPrimary.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorUtils.volunteerSuccess.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.volunteer_activism,
                      color: ColorUtils.volunteerSuccess,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "This food is for FREE! 😊",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.volunteerSuccess,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Strictly no selling - Help feed the community",
                            style: TextStyle(
                              fontSize: 13,
                              color: ColorUtils.volunteerTextSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // Donor Details Section
              buildDonorPickUpAddressDetails(),

              // Only show recipient section if recipient data exists
              if (_volunteerFoodDescriptionModelData?.recipientName.isNotEmpty == true) ...[
                const SizedBox(height: 20),
                buildRecipientDropAddressDetails(),
              ],

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
                    backgroundColor: (status == Constants.STATUS_AVAILABLE || 
                                     status == Constants.pick_up_scheduled || 
                                     status == Constants.collected_food)
                        ? ColorUtils.volunteerPrimary
                        : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                ),
                onPressed: (status == Constants.STATUS_AVAILABLE || 
                           status == Constants.pick_up_scheduled || 
                           status == Constants.collected_food)
                    ? ()
                    {
                      print("Button pressed! Current status: $status");
                      if (status == Constants.STATUS_AVAILABLE) {
                        // Assign volunteer to collect and drop the food
                        _collectFood(addedFoodModel.userId, null, addedFoodModel.id);
                      } else if (status == Constants.pick_up_scheduled) {
                        // Mark as picked up
                        _markPickedUp(addedFoodModel.userId, addedFoodModel.id);
                      } else if (status == Constants.collected_food) {
                        // Mark as delivered
                        _markDelivered(addedFoodModel.userId, addedFoodModel.id);
                      }
                    }
                    : null,
                child: Text(
                  _getButtonText(status),
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false,
    bool isClickable = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: ColorUtils.volunteerSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ColorUtils.volunteerTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isClickable && value != "N/A" && value != "Not assigned yet"
                  ? ColorUtils.volunteerPrimary
                  : ColorUtils.volunteerTextPrimary,
              fontWeight: FontWeight.w500,
              decoration: isClickable && value != "N/A" && value != "Not assigned yet"
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
            maxLines: isMultiline ? null : 1,
            overflow: isMultiline ? null : TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }


  Widget buildDonorPickUpAddressDetails() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: Card(
      elevation: 6,
      color: ColorUtils.volunteerCardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.store,
                  color: ColorUtils.volunteerPrimary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Pickup & Donor Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.volunteerTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 3,
              width: 60,
              decoration: BoxDecoration(
                gradient: ColorUtils.volunteerGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            // Name
            _buildDetailRow(
              icon: Icons.person,
              label: "Name",
              value: _volunteerFoodDescriptionModelData?.donorName ?? addedFoodModel.businessName,
            ),

            const SizedBox(height: 16),

            // Business Name
            _buildDetailRow(
              icon: Icons.business,
              label: "Business Name",
              value: _volunteerFoodDescriptionModelData?.donorBusinessName ?? addedFoodModel.businessName,
            ),

            const SizedBox(height: 16),

            // Contact Number
            _buildDetailRow(
              icon: Icons.phone,
              label: "Contact Number",
              value: _volunteerFoodDescriptionModelData?.donorContactNumber ?? "Contact via app",
              isClickable: _volunteerFoodDescriptionModelData?.donorContactNumber.isNotEmpty == true,
            ),

            const SizedBox(height: 16),

            // Address
            _buildDetailRow(
              icon: Icons.location_on,
              label: "Pickup Address",
              value: _volunteerFoodDescriptionModelData?.donorAddress ?? addedFoodModel.pickUpAddress,
              isMultiline: true,
            ),
          ],
        ),
      ),
    ),
  );

  Widget buildRecipientDropAddressDetails() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: Card(
      elevation: 6,
      color: ColorUtils.volunteerCardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.local_shipping,
                  color: ColorUtils.volunteerSecondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Delivery & Recipient Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.volunteerTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 3,
              width: 60,
              decoration: BoxDecoration(
                color: ColorUtils.volunteerSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            // Name
            _buildDetailRow(
              icon: Icons.person,
              label: "Name",
              value: _volunteerFoodDescriptionModelData?.recipientName ?? "Not assigned yet",
            ),

            const SizedBox(height: 16),

            // Business Name
            _buildDetailRow(
              icon: Icons.business,
              label: "Business Name",
              value: _volunteerFoodDescriptionModelData?.recipientBusinessName ?? "Not assigned yet",
            ),

            const SizedBox(height: 16),

            // Contact Number
            _buildDetailRow(
              icon: Icons.phone,
              label: "Contact Number",
              value: _volunteerFoodDescriptionModelData?.recipientContactNumber ?? "Not assigned yet",
              isClickable: _volunteerFoodDescriptionModelData?.recipientContactNumber.isNotEmpty == true,
            ),

            const SizedBox(height: 16),

            // Address
            _buildDetailRow(
              icon: Icons.location_on,
              label: "Delivery Address",
              value: _volunteerFoodDescriptionModelData?.recipientAddress ?? "Not assigned yet",
              isMultiline: true,
            ),
          ],
        ),
      ),
    ),
  );

  void _getFoodItemDetails(donorUserId, recipientUserId)
  {
    setState(() {
      isLoading = true;
    });

    Map body = {
      "donor_user_id":donorUserId,
    };

    // print(jsonEncode(body));

    try
    {
      print("--- API Call Debug ---");
      print("Request body: ${jsonEncode(body)}");
      
      Future<VolunteerFoodDescriptionModel> response = ApiService.getFoodItemDetails(jsonEncode(body));
      response.then((obj){
        print("API Response received");
        print("Error: ${obj.error}");
        print("Message: ${obj.message}");

        setState(() {
          isLoading = false;
        });

        if (!obj.error)
        {
          if (obj.message == Constants.success)
          {
            print("Success! Setting donor data");
            print("Donor name: ${obj.data.donorName}");
            print("Donor business: ${obj.data.donorBusinessName}");
            print("Donor contact: ${obj.data.donorContactNumber}");
            print("Donor address: ${obj.data.donorAddress}");

            setState(() {
              _volunteerFoodDescriptionModelData = obj.data;
            });
          }
          else
          {
            print("API returned error message: ${obj.message}");
            Constants.showToast(obj.message);
          }
        }
        else
        {
          print("API returned error flag true");
          Constants.showToast("Failed to load donor details");
        }
      }).catchError((onError)
      {
        print("API call failed with error: $onError");
        setState(() {
          isLoading = false;
        });
        Constants.showToast("Network error: ${onError.toString()}");
      }
      );

    }
    on Exception {
      // print(e);
      Constants.showToast("Please try again");
    }

  }

  String _getButtonText(String status) {
    switch (status) {
      case Constants.STATUS_AVAILABLE:
        return "Let me collect and drop";
      case Constants.pick_up_scheduled:
        return "Mark as Picked Up";
      case Constants.collected_food:
        return "Mark as Delivered";
      case Constants.delivered:
        return "Delivered";
      default:
        return status;
    }
  }

  void _collectFood(donorUserId, recipientUserId, foodId)
  {
    setState(() {
      isLoading = true;
    });

    Map body = {
      "donor_user_id":donorUserId,
      "volunteer_user_id":_userId,
      "food_item_id": foodId
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

            // Show success message based on previous status
            if (status == Constants.STATUS_AVAILABLE) {
              Constants.showToast("You've been assigned! Please collect and deliver the food.");
            } else {
              Constants.showToast("Food collection confirmed!");
            }

            setState(() {
              status = Constants.pick_up_scheduled;
            });
          }
          else
          {
            Constants.showToast(obj['message']);

          }
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

  void _markPickedUp(donorUserId, foodId)
  {
    setState(() {
      isLoading = true;
    });

    Map body = {
      "donor_user_id":donorUserId,
      "volunteer_user_id":_userId,
      "food_item_id": foodId
    };

    try
    {
      Future<dynamic> response = ApiService.markPickedUp(jsonEncode(body));
      response.then((obj){

        setState(() {
          isLoading = false;
        });

        if (!obj['error'])
        {
          if (obj['message'] == Constants.success)
          {
            reload = true;
            Constants.showToast("Food picked up successfully!");

            setState(() {
              status = Constants.collected_food;
            });
          }
          else
          {
            Constants.showToast(obj['message']);
          }
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
      Constants.showToast("Please try again");
    }

  }

  void _markDelivered(donorUserId, foodId)
  {
    setState(() {
      isLoading = true;
    });

    Map body = {
      "donor_user_id":donorUserId,
      "volunteer_user_id":_userId,
      "food_item_id": foodId
    };

    try
    {
      Future<dynamic> response = ApiService.markDelivered(jsonEncode(body));
      response.then((obj){

        setState(() {
          isLoading = false;
        });

        if (!obj['error'])
        {
          if (obj['message'] == Constants.success)
          {
            reload = true;
            Constants.showToast("Food delivered successfully! 🎉");

            setState(() {
              status = Constants.delivered;
            });
          }
          else
          {
            Constants.showToast(obj['message']);
          }
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
      Constants.showToast("Please try again");
    }

  }

  void _handoverToShelter(donorUserId, foodId)
  {
    setState(() {
      isLoading = true;
    });

    Map body = {
      "donor_user_id":donorUserId,
      "volunteer_user_id":_userId,
      "food_item_id": foodId
    };

    // print(jsonEncode(body));

    try
    {
      Future<dynamic> response = ApiService.handoverToShelter(jsonEncode(body));
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
              status = Constants.delivered;
            });
          }
          else
          {
            Constants.showToast(obj['message']);

          }
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
}

