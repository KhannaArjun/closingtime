

class VolunteerFoodListModel {
  VolunteerFoodListModel({
    required this.data,
    required this.error,
    required this.message,
  });
  late final List<Data> data;
  late final bool error;
  late final String message;

  VolunteerFoodListModel.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['error'] = error;
    _data['message'] = message;
    return _data;
  }
}

class Data {
  Data({
    required this.allergen,
    required this.businessName,
    required this.distance,
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
    required this.recipientUserId,
    required this.status,
    required this.timestamp,
    required this.userId,
  });
  late final String allergen;
  late final String businessName;
  late final String distance;
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
  late final String recipientUserId;
  late final String status;
  late final int timestamp;
  late final String userId;

  Data.fromJson(Map<String, dynamic> json){
    allergen = json['allergen'];
    businessName = json['business_name'];
    distance = json['distance'];
    foodDesc = json['food_desc'];
    foodIngredients = json['food_ingredients'];
    foodName = json['food_name'];
    id = json['id'];
    image = json['image'];
    isFoodAccepted = json['isFoodAccepted'];
    pickUpAddress = json['pick_up_address'];
    pickUpDate = json['pick_up_date'];
    pickUpTime = json['pick_up_time'];
    pickUpLat = json['pick_up_lat'];
    pickUpLng = json['pick_up_lng'];
    quantity = json['quantity'];
    recipientUserId = json['recipient_user_id'];
    status = json['status'];
    timestamp = json['timestamp'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['allergen'] = allergen;
    _data['business_name'] = businessName;
    _data['distance'] = distance;
    _data['food_desc'] = foodDesc;
    _data['food_ingredients'] = foodIngredients;
    _data['food_name'] = foodName;
    _data['id'] = id;
    _data['image'] = image;
    _data['isFoodAccepted'] = isFoodAccepted;
    _data['pick_up_address'] = pickUpAddress;
    _data['pick_up_date'] = pickUpDate;
    _data['pick_up_time'] = pickUpTime;
    _data['pick_up_lat'] = pickUpLat;
    _data['pick_up_lng'] = pickUpLng;
    _data['quantity'] = quantity;
    _data['recipient_user_id'] = recipientUserId;
    _data['status'] = status;
    _data['timestamp'] = timestamp;
    _data['user_id'] = userId;
    return _data;
  }
}