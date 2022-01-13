// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'package:closingtime/registration/volunteer_registration.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

VolunteerRegistrationResponse foodRecipientRegistrationFromJson(String str) => VolunteerRegistrationResponse.fromJson(json.decode(str));

String foodRecipientRegistrationToJson(VolunteerRegistrationResponse data) => json.encode(data.toJson());

class VolunteerRegistrationResponse {
  VolunteerRegistrationResponse({
    required this.data,
    required this.error,
    required this.message,
  });

  Data data;
  bool error;
  String message;

  factory VolunteerRegistrationResponse.fromJson(Map<String, dynamic> json) => VolunteerRegistrationResponse(
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
    required this.contactNumber,
    required this.email,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.userId,
    required this.role,
  });

  String contactNumber;
  String email;
  String name;
  String userId;
  String role;
  String address;
  double lat;
  double lng;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    contactNumber: json["contact_number"],
    email: json["email"],
    name: json["name"],
    address: json["address"],
    lat: json["lat"],
    lng: json["lng"],
    userId: json["user_id"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "contact_number": contactNumber,
    "email": email,
    "name": name,
    "address": address,
    "lat": lat,
    "lng": lng,
    "user_id": userId,
    "role": role,
  };

  @override
  String toString() {
    return 'Data{contactNumber: $contactNumber, email: $email,'
        ' name: $name, ,userId: $userId}, role: $role, address: $address, lat: $lat, lng: $lng}';
  }
}
