// To parse this JSON data, do
//
//     final addedFoodListModel = addedFoodListModelFromJson(jsonString);

import 'package:meta/meta.dart';
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
  });

  String foodDesc;
  String foodName;
  String id;
  String pickUpDate;
  String quantity;
  String userId;
  String foodIngredients;
  String image;
  String allergen;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    foodDesc: json["food_desc"],
    foodName: json["food_name"],
    id: json["id"],
    pickUpDate: json["pick_up_date"],
    quantity: json["quantity"],
    userId: json["user_id"],
    foodIngredients: json["food_ingredients"],
    image: json["image"],
    allergen: json["allergen"],
  );

  Map<String, dynamic> toJson() => {
    "food_desc": foodDesc,
    "food_name": foodName,
    "id": id,
    "pick_up_date": pickUpDate,
    "quantity": quantity,
    "user_id": userId,
    "food_ingredients": foodIngredients,
    "image": image,
    "allergen": allergen,
  };
}
