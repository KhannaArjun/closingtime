// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.data,
    required this.error,
    required this.message,
  });

  Data data;
  bool error;
  String message;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    data: Data.fromJson(json["data"]),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "error": error,
    "message": message,
  };
}

class Data {
  Data({
    required this.businessName,
    required this.contactNumber,
    required this.email,
    required this.name,
    required this.postcode,
    required this.streetName,
    required this.userId,
  });

  String businessName;
  String contactNumber;
  String email;
  String name;
  String postcode;
  String streetName;
  String userId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    businessName: json["business_name"],
    contactNumber: json["contact_number"],
    email: json["email"],
    name: json["name"],
    postcode: json["postcode"],
    streetName: json["street_name"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "business_name": businessName,
    "contact_number": contactNumber,
    "email": email,
    "name": name,
    "postcode": postcode,
    "street_name": streetName,
    "user_id": userId,
  };
}
