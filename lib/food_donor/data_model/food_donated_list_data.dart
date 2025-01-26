// To parse this JSON data, do
//
//     final addedFoodListModel = addedFoodListModelFromJson(jsonString);

import 'dart:convert';

AddedFoodListModel addedFoodListModelFromJson(String str) => AddedFoodListModel.fromJson(json.decode(str));

String addedFoodListModelToJson(AddedFoodListModel data) => json.encode(data.toJson());

class AddedFoodListModel {
  AddedFoodListModel({
    required this.data,
    required this.error,
    required this.message,
  });

  List<Data> data;
  bool error;
  String message;

  factory AddedFoodListModel.fromJson(Map<String, dynamic> json) => AddedFoodListModel(
    data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class Data {
  Data({
    required this.foodDesc,
    required this.foodName,
    required this.id,
    required this.pickUpDate,
    required this.quantity,
    required this.userId,
    required this.image,
    required this.foodIngredients,
    required this.allergen,
    required this.pickUpAddress,
    required this.isFoodAccepted,
    required this.pickUpTime,
    required this.business_name,
    required this.status,
    required this.distance,
  });

  String foodDesc;
  String foodName;
  String id;
  String pickUpDate;
  String pickUpTime;
  String quantity;
  String userId;
  String foodIngredients;
  String image;
  String allergen;
  String pickUpAddress;
  bool isFoodAccepted = false;
  String business_name;
  String status;
  String distance;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    foodDesc: json["food_desc"],
    foodName: json["food_name"],
    id: json["id"],
    pickUpDate: json["pick_up_date"],
    pickUpTime: json["pick_up_time"],
    quantity: json["quantity"],
    userId: json["user_id"],
    foodIngredients: json["food_ingredients"],
    image: json["image"],
    allergen: json["allergen"],
    pickUpAddress: json["pick_up_address"],
    isFoodAccepted: json["isFoodAccepted"],
    business_name: json["business_name"],
    status: json["status"],
    distance: json["distance"],
  );

  Map<String, dynamic> toJson() => {
    "food_desc": foodDesc,
    "food_name": foodName,
    "id": id,
    "pick_up_date": pickUpDate,
    "pick_up_time": pickUpTime,
    "quantity": quantity,
    "user_id": userId,
    "food_ingredients": foodIngredients,
    "image": image,
    "allergen": allergen,
    "pick_up_address": pickUpAddress,
    "isFoodAccepted": isFoodAccepted,
    "business_name": business_name,
    "status": status,
    "distance": distance,
  };
}
