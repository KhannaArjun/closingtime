class RecipientProfileResponse {
  RecipientProfileResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  late final bool error;
  late final String message;
  late final RecipientProfileModel data;

  RecipientProfileResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    data = RecipientProfileModel.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{}; // Renamed from 'data' to 'jsonData'
    jsonData['error'] = error;
    jsonData['message'] = message;
    jsonData['data'] = data.toJson(); // Correctly references the class-level 'data'
    return jsonData;
  }
}
class RecipientProfileModel {
  RecipientProfileModel({
    required this.address,
    required this.businessName,
    required this.code,
    required this.contactNumber,
    required this.email,
    required this.lat,
    required this.lng,
    required this.name,
    required this.placeId,
    required this.role,
    required this.userId,
  });

  late final String address;
  late final String businessName;
  late final String code;
  late final String contactNumber;
  late final String email;
  late final double lat;
  late final double lng;
  late final String name;
  late final String placeId;
  late final String role;
  late final String userId;

  RecipientProfileModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    businessName = json['business_name'];
    code = json['code'];
    contactNumber = json['contact_number'];
    email = json['email'];
    lat = json['lat'];
    lng = json['lng'];
    name = json['name'];
    placeId = json['place_id'];
    role = json['role'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData['address'] = address;
    jsonData['business_name'] = businessName;
    jsonData['code'] = code;
    jsonData['contact_number'] = contactNumber;
    jsonData['email'] = email;
    jsonData['lat'] = lat;
    jsonData['lng'] = lng;
    jsonData['name'] = name;
    jsonData['place_id'] = placeId;
    jsonData['role'] = role;
    jsonData['user_id'] = userId;
    return jsonData;
  }
}
