import 'dart:convert';

DonorProfileResponse addedFoodListModelFromJson(String str) => DonorProfileResponse.fromJson(json.decode(str));

String addedFoodListModelToJson(DonorProfileResponse data) => json.encode(data.toJson());

class DonorProfileResponse {
  DonorProfileResponse({
    required this.error,
    required this.message,
    required this.data,
  });
  late final bool error;
  late final String message;
  late final DonorProfileModel data;

  DonorProfileResponse.fromJson(Map<String, dynamic> json){
    error = json['error'];
    message = json['message'];
    data = DonorProfileModel.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class DonorProfileModel {
  DonorProfileModel({
    required this.userId,
    required this.name,
    required this.businessName,
    required this.email,
    required this.password,
    required this.contactNumber,
    required this.streetName,
    required this.area,
    required this.country,
    required this.postcode,
  });
   String userId = "";
  String name = "";
  String businessName= "";
  String email= "";
  String password= "";
 String contactNumber= "";
 String streetName= "";
String area= "";
 String country= "";
 String postcode= "";

  DonorProfileModel.fromJson(Map<String, dynamic> json){
    userId = json['user_id'];
    name = json['name'];
    businessName = json['business_name'];
    email = json['email'];
    password = json['password'];
    contactNumber = json['contact_number'];
    streetName = json['street_name'];
    area = json['area_name'];
    country = json['country'];
    postcode = json['postcode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['name'] = name;
    _data['business_name'] = businessName;
    _data['email'] = email;
    _data['password'] = password;
    _data['contact_number'] = contactNumber;
    _data['street_name'] = streetName;
    _data['area'] = area;
    _data['country'] = country;
    _data['postcode'] = postcode;
    return _data;
  }
}