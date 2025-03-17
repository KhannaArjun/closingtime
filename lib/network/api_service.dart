import 'dart:convert';

import 'package:closingtime/food_donor/data_model/donor_profile_model.dart';
import 'package:closingtime/food_donor/data_model/food_donated_list_data.dart';
import 'package:closingtime/food_recipient/data_model/recipient_profile_model.dart';
import 'package:closingtime/food_recipient/data_model/recipient_registration_model.dart';
import 'package:closingtime/network/entity/donor/donor_registration_model.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:closingtime/volunteer/data_model/volunteer_food_description_model.dart';
import 'package:closingtime/volunteer/data_model/volunteer_food_list_response.dart';
import 'package:closingtime/volunteer/data_model/volunteer_registration_model.dart';
import 'package:http/http.dart' as http;

import 'entity/login_model.dart';


 class ApiService
{
  static Uri parseUri(endpoint)
  {
    String url = Constants.BASE_URL + endpoint;
   return Uri.parse(url);
  }

  static Future<dynamic> test() async {
    final response = await http
        .post(parseUri('/food_donor/registration'));

    if (response.statusCode == 200)
    {
      return jsonDecode(response.body);
    }
    else
    {
      // print(response.statusCode);
      throw Exception(response.toString());
    }
  }

  static Future<FoodDonorRegistration> donorRegistration(body) async {
    final response = await http
        .post(parseUri('/food_donor/registration'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
      {
        return FoodDonorRegistration.fromJson(jsonDecode(response.body));
      }
    else
      {
        // print(response.toString());
        throw Exception('Failed');
      }

  }

  static Future<FoodDonorRegistration> donorUpdateProfile(body) async {
    final response = await http
        .post(parseUri('/food_donor/update_profile'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      return FoodDonorRegistration.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response.toString());
      throw Exception('Failed');
    }
  }

  static Future<dynamic> addFood(body) async {
    final response = await http
        .post(parseUri('/food_donor/add_food'),
        headers: Constants.HEADERS, body: body);
    // print(response.body);

    if (response.statusCode == 200)
      {
        return jsonDecode(response.body);
      }
    else
      {
        // print(response);
        throw Exception('Failed');
      }
  }


  static Future<AddedFoodListModel> addedFoodList(body) async {
    final response = await http
        .post(parseUri('/food_donor/added_food_list'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      print(response.body);
      return AddedFoodListModel.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response);
      throw Exception('Failed');
    }

  }

  static Future<AddedFoodListModel> modifyFoodItem(body) async {
    final response = await http
        .post(parseUri('/food_donor/modify_food_item'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      // print(response.body);
      return AddedFoodListModel.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response);
      throw Exception('Failed');
    }

  }


  static Future<AddedFoodListModel> getFoodHistoryByDonor(body) async {
    final response = await http
        .post(parseUri('/food_donor/getAllFoodsByDonor'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      // print(response.body);
      return AddedFoodListModel.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response);
      throw Exception('Failed');
    }

  }

  static Future<VolunteerFoodListModel> getFoodHistoryByVolunteer(body) async {
    final response = await http
        .post(parseUri('/volunteer/getAllFoodsByVolunteer'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      // print(response.body);
      return VolunteerFoodListModel.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response);
      throw Exception('Failed');
    }

  }

  static Future<AddedFoodListModel> getFoodHistoryByRecipeint(body) async {
    final response = await http
        .post(parseUri('/recipient/getAllFoodsByRecipient'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      // print(response.body);
      return AddedFoodListModel.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response);
      throw Exception('Failed');
    }

  }

  static Future<VolunteerFoodListModel> getAvailableFoodListForVolunteer(body) async {
    final response = await http
        .post(parseUri('/volunteer/getAvailableFoodList'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      // print(response.body);
      return VolunteerFoodListModel.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response);
      throw Exception('Failed');
    }

  }

  static Future<AddedFoodListModel> getAllFoodList(body) async {
    final response = await http
        .post(parseUri('/recipient/getAvailableFoodList'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      // print(response.body);
      return AddedFoodListModel.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response.statusCode);
      throw Exception('Failed');
    }

  }


  static Future<dynamic> accept_food(body) async {
    final response = await http
        .post(parseUri('/recipient/accept_food'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      // print(response.body);
      return jsonDecode(response.body);
    }
    else
    {
      // print(response);
      throw Exception('Failed');
    }

  }

  static Future<VolunteerFoodDescriptionModel> getFoodItemDetails(body) async {
    final response = await http
        .post(parseUri('/volunteer/getFoodItemDetails'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      // print(response.body);
      return VolunteerFoodDescriptionModel.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response);
      throw Exception('Failed');
    }
  }

  static Future<dynamic> collectFood(body) async
  {
    final response = await http
        .post(parseUri('/volunteer/collect_food'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      // print(response.body);
      return jsonDecode(response.body);
    }
    else
    {
      // print(response.statusCode);
      throw Exception('Failed');
    }
  }

  static Future<dynamic> foodDelivered(body) async
  {
    final response = await http
        .post(parseUri('/recipient/food_delivered'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      // print(response.body);
      return jsonDecode(response.body);
    }
    else
    {
      // print(response.statusCode);
      throw Exception('Failed');
    }
  }

  static Future<dynamic> removeFoodItemList(body) async {
    final response = await http
        .post(parseUri('/food_donor/remove_food_item'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      // print(response.body);
      return jsonDecode(response.body);
    }
    else
    {
      // print(response);
      throw Exception('Failed');
    }

  }

  static Future<dynamic> logout(body) async {
    final response = await http
        .post(parseUri('/logout'),
        headers: Constants.HEADERS, body: body);

    if (response.statusCode == 200)
    {
      // print(response.body);
      return jsonDecode(response.body);
    }
    else
    {
      // print(response);
      throw Exception('Failed');
    }
  }

  static Future<LoginModel> login(body) async {
    final response = await http
        .post(parseUri('/login'), headers: {
      'Content-Type': 'application/json',
    }, body: body, );

    if (response.statusCode == 200)
    {
      return LoginModel.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response.statusCode);
      throw Exception('Failed');
    }
  }


  static Future<dynamic> checkIsUserExists(body) async {
    final response = await http
        .post(parseUri('/isUserExists'), headers: {
      'Content-Type': 'application/json',
    }, body: body, );

    if (response.statusCode == 200)
    {
        return jsonDecode(response.body);
    }
    else
    {
      // print(response.statusCode);
      throw Exception('Failed');
    }

  }


  static Future<DonorProfileResponse> getDonorProfile(body) async {
    final response = await http
        .post(parseUri('/food_donor/getUserProfile'), headers: {
      'Content-Type': 'application/json',
    }, body: body, );

    if (response.statusCode == 200)
    {
      // print(response.body);
      return DonorProfileResponse.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response.statusCode);
      throw Exception('Failed');
    }
  }

  static Future<RecipientProfileResponse> getRecipientProfile(body) async {
    final response = await http
        .post(parseUri('/recipient/getUserProfile'), headers: {
      'Content-Type': 'application/json',
    }, body: body, );

    if (response.statusCode == 200)
    {
      // print(response.body);
      return RecipientProfileResponse.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response.statusCode);
      throw Exception('Failed');
    }
  }

  static Future<FoodRecipientRegistration> recipientRegistration(body) async
  {

    final response = await http
        .post(parseUri('/recipient/registration'),
        headers: Constants.HEADERS, body: body);


    if (response.statusCode == 200)
    {

      return FoodRecipientRegistration.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response.toString());
      throw Exception('Failed');
    }

  }

  static Future<FoodRecipientRegistration> recipientUpdateProfile(body) async
  {

    final response = await http
        .post(parseUri('/recipient/update_profile'),
        headers: Constants.HEADERS, body: body);



    if (response.statusCode == 200)
    {

      return FoodRecipientRegistration.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response.toString());
      throw Exception('Failed');
    }

  }

  static Future<VolunteerRegistrationResponse> volunteerRegistration(body) async
  {

    final response = await http
        .post(parseUri('/volunteer/registration'),
        headers: Constants.HEADERS, body: body);


    if (response.statusCode == 200)
    {

      return VolunteerRegistrationResponse.fromJson(jsonDecode(response.body));
    }
    else
    {
      // print(response.toString());
      throw Exception('Failed');
    }

  }

  static Future<VolunteerRegistrationResponse> volunteerUpdateProfile(body) async
  {

      final response = await http
          .post(parseUri('/volunteer/update_profile'),
          headers: Constants.HEADERS, body: body);


      if (response.statusCode == 200)
      {

        return VolunteerRegistrationResponse.fromJson(jsonDecode(response.body));
      }
      else
        {
          throw Error();
        }

  }
}