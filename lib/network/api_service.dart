import 'dart:convert';

import 'package:closingtime/food_donor/data_model/donor_profile_model.dart';
import 'package:closingtime/food_donor/data_model/food_donated_list_data.dart';
import 'package:closingtime/network/entity/donor/donor_registration%7C_model.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'entity/login_model.dart';


 class ApiService
{
  static Uri parseUri(endpoint)
  {
    String url = Constants.BASE_URL + endpoint;
    print(url);
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
      print(response.statusCode);
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
        print(response);
        throw Exception('Failed');
      }

  }

  static Future<dynamic> addFood(body) async {
    final response = await http
        .post(parseUri('/food_donor/add_food'),
        headers: Constants.HEADERS, body: body);
    print(response.body);

    if (response.statusCode == 200)
      {
        return jsonDecode(response.body);
      }
    else
      {
        print(response);
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
      print(response);
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
      print(response.statusCode);
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
      print(response.body);
      return DonorProfileResponse.fromJson(jsonDecode(response.body));
    }
    else
    {
      print(response.statusCode);
      throw Exception('Failed');
    }
  }
}