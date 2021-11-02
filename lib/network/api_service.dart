import 'dart:convert';

import 'package:closingtime/network/entity/donor/donor_registration%7C_model.dart';
import 'package:closingtime/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'entity/login_model.dart';


 class ApiService
{
  static Uri parseUri(endpoint)
  {
   return Uri.parse(Constants.BASE_URL + endpoint);
  }

  static Future<FoodDonorRegistration> donorRegistration(body) async {
    final response = await http
        .post(parseUri('/food_donor/registration'), body: body);

    if (response.statusCode == 200)
      {
        return FoodDonorRegistration.fromJson(jsonDecode(response.body));
      }
    else
      {
        print(response.statusCode);
        throw Exception('Failed');
      }

  }

  static Future<LoginModel> login(body) async {
    final response = await http
        .post(parseUri('/login'), body: body);

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
}