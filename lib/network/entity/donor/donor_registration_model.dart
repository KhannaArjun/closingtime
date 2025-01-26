// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

FoodDonorRegistration foodDonorRegistrationFromJson(String str) => FoodDonorRegistration.fromJson(json.decode(str));

String foodDonorRegistrationToJson(FoodDonorRegistration data) => json.encode(data.toJson());

class FoodDonorRegistration {
  FoodDonorRegistration({
    required this.data,
    required this.error,
    required this.message,
  });

  Data data;
  bool error;
  String message;

  factory FoodDonorRegistration.fromJson(Map<String, dynamic> json) => FoodDonorRegistration(
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
    // required this.postcode,
    // required this.streetName,
    // required this.areaName,
    // required this.stateName,
    // required this.country,
    required this.address,
    required this.lat,
    required this.lng,
    required this.userId,
    required this.role,
  });

  String businessName;
  String contactNumber;
  String email;
  String name;
  // String postcode;
  // String streetName;
  // String areaName;
  // String stateName;
  // String country;
  String userId;
  String role;
  String address;
  double lat;
  double lng;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    businessName: json["business_name"],
    contactNumber: json["contact_number"],
    email: json["email"],
    name: json["name"],
    // postcode: json["postcode"],
    // streetName: json["street_name"],
    // areaName: json["area_name"],
    // stateName: json["state_name"],
    // country: json["country"],

    address: json["address"],
    lat: json["lat"],
    lng: json["lng"],
    userId: json["user_id"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "business_name": businessName,
    "contact_number": contactNumber,
    "email": email,
    "name": name,
    // "postcode": postcode,
    // "street_name": streetName,
    // "area_name": areaName,
    // "state_name": stateName,
    // "country": country,
    "address": address,
    "lat": lat,
    "lng": lng,
    "user_id": userId,
    "role": role,
  };

  @override
  String toString() {
    return 'Data{businessName: $businessName, contactNumber: $contactNumber, email: $email,'
        ' name: $name, ,userId: $userId}, role: $role, address: $address, lat: $lat, lng: $lng}';
  }
}
