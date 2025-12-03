class VolunteerFoodListModel {
  VolunteerFoodListModel({
    required this.data,
    required this.error,
    required this.message,
  });

  late final List<Data> data;
  late final bool error;
  late final String message;

  VolunteerFoodListModel.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData['data'] = data.map((e) => e.toJson()).toList();
    jsonData['error'] = error;
    jsonData['message'] = message;
    return jsonData;
  }
}


class Data {
  Data({
    required this.address,
    required this.allergen,
    required this.businessEmail,
    required this.businessName,
    required this.createdAt,
    required this.distance,
    required this.donationType,
    required this.foodDesc,
    required this.foodIngredients,
    required this.foodName,
    required this.id,
    required this.image,
    required this.isFoodAccepted,
    required this.pickUpAddress,
    required this.pickUpDate,
    required this.pickUpTime,
    required this.pickUpLat,
    required this.pickUpLng,
    required this.quantity,
    required this.status,
    required this.token,
    required this.userId,
  });
  late final String address;
  late final String allergen;
  late final String businessEmail;
  late final String businessName;
  late final String createdAt;
  late final String distance;
  late final String donationType;
  late final String foodDesc;
  late final String foodIngredients;
  late final String foodName;
  late final String id;
  late final String image;
  late final bool isFoodAccepted;
  late final String pickUpAddress;
  late final String pickUpDate;
  late final String pickUpTime;
  late final double pickUpLat;
  late final double pickUpLng;
  late final String quantity;
  late final String status;
  late final String token;
  late final String userId;

  Data.fromJson(Map<String, dynamic> json){
    address = json['address'] ?? '';
    allergen = json['allergen'] ?? '';
    businessEmail = json['business_email'] ?? '';
    businessName = json['business_name'] ?? '';
    createdAt = json['created_at'] ?? '';
    distance = json['distance'] ?? '';
    donationType = json['donation_type'] ?? '';
    foodDesc = json['food_desc'] ?? '';
    foodIngredients = json['food_ingredients'] ?? '';
    foodName = json['food_name'] ?? '';
    id = json['id'] ?? '';
    image = json['image'] ?? '';
    isFoodAccepted = json['isFoodAccepted'] ?? false;
    pickUpAddress = json['pick_up_address'] ?? '';
    pickUpDate = json['pick_up_date'] ?? '';
    pickUpTime = json['pick_up_time'] ?? '';
    pickUpLat = json['pick_up_lat'] ?? 0.0;
    pickUpLng = json['pick_up_lng'] ?? 0.0;
    quantity = json['quantity'] ?? '';
    status = json['status'] ?? '';
    token = json['token'] ?? '';
    userId = json['user_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['address'] = address;
    data['allergen'] = allergen;
    data['business_email'] = businessEmail;
    data['business_name'] = businessName;
    data['created_at'] = createdAt;
    data['distance'] = distance;
    data['donation_type'] = donationType;
    data['food_desc'] = foodDesc;
    data['food_ingredients'] = foodIngredients;
    data['food_name'] = foodName;
    data['id'] = id;
    data['image'] = image;
    data['isFoodAccepted'] = isFoodAccepted;
    data['pick_up_address'] = pickUpAddress;
    data['pick_up_date'] = pickUpDate;
    data['pick_up_time'] = pickUpTime;
    data['pick_up_lat'] = pickUpLat;
    data['pick_up_lng'] = pickUpLng;
    data['quantity'] = quantity;
    data['status'] = status;
    data['token'] = token;
    data['user_id'] = userId;
    return data;
  }
}