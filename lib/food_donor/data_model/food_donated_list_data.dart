// lib/food_donor/data_model/food_donated_list_data.dart
import 'dart:convert';

AddedFoodListModel addedFoodListModelFromJson(String str) =>
    AddedFoodListModel.fromJson(json.decode(str));

String addedFoodListModelToJson(AddedFoodListModel data) =>
    json.encode(data.toJson());

class AddedFoodListModel {
  AddedFoodListModel({
    required this.data,
    required this.error,
    required this.message,
  });

  final List<Data> data;
  final bool error;
  final String message;

  factory AddedFoodListModel.fromJson(Map<String, dynamic> j) => AddedFoodListModel(
    data: ((j['data'] as List?) ?? const [])
        .map((e) => Data.fromJson((e as Map).cast<String, dynamic>()))
        .toList(),
    error: (j['error'] as bool?) ?? false,
    message: (j['message'] as String?) ?? '',
  );

  Map<String, dynamic> toJson() => {
    'data': data.map((x) => x.toJson()).toList(),
    'error': error,
    'message': message,
  };
}

class Data {
  Data({
    required this.foodDesc,
    required this.foodName,
    required this.id,
    required this.pickUpDate,
    required this.pickUpTime,
    required this.quantity,
    required this.userId,
    required this.foodIngredients,
    required this.image,
    required this.allergen,
    required this.pickUpAddress,
    required this.isFoodAccepted,
    required this.business_name,
    required this.status,
    required this.distance,
  });

  final String foodDesc;
  final String foodName;
  final String id;
  final String pickUpDate;
  final String pickUpTime;
  final String quantity;    // normalize to String
  final String userId;
  final String foodIngredients;
  final String image;
  final String allergen;
  final String pickUpAddress;
  final bool   isFoodAccepted;
  final String business_name;
  final String status;
  final String distance;    // may be absent -> ''

  factory Data.fromJson(Map<String, dynamic> j) => Data(
    foodDesc:        (j['food_desc'] as String?) ?? '',
    foodName:        (j['food_name'] as String?) ?? '',
    id:              (j['id'] as String?) ?? '',
    pickUpDate:      (j['pick_up_date'] as String?) ?? '',
    pickUpTime:      (j['pick_up_time'] as String?) ?? '',
    quantity:        j['quantity']?.toString() ?? '',
    userId:          (j['user_id'] as String?) ?? '',
    foodIngredients: (j['food_ingredients'] as String?) ?? '',
    image:           (j['image'] as String?) ?? '',
    allergen:        (j['allergen'] as String?) ?? '',
    pickUpAddress:   (j['pick_up_address'] as String?) ?? '',
    isFoodAccepted:  (j['isFoodAccepted'] as bool?) ?? false,
    business_name:   (j['business_name'] as String?) ?? '',
    status:          (j['status'] as String?) ?? '',
    distance:        j['distance']?.toString() ?? '',  // <-- key fix
  );

  Map<String, dynamic> toJson() => {
    'food_desc':        foodDesc,
    'food_name':        foodName,
    'id':               id,
    'pick_up_date':     pickUpDate,
    'pick_up_time':     pickUpTime,
    'quantity':         quantity,
    'user_id':          userId,
    'food_ingredients': foodIngredients,
    'image':            image,
    'allergen':         allergen,
    'pick_up_address':  pickUpAddress,
    'isFoodAccepted':   isFoodAccepted,
    'business_name':    business_name,
    'status':           status,
    'distance':         distance,
  };
}
