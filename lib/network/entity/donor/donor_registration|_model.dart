import 'package:json_annotation/json_annotation.dart';

class FoodDonorRegistration {
  Data? _data;
  bool _error = false;
  String _message = "";

  FoodDonorRegistration({required Data data, required bool error, required String message}) {
    this._data = data;
    this._error = error;
    this._message = message;
  }

  Data? get data => _data;

  set data(Data? data) => _data = data;

  bool get error => _error;

  set error(bool error) => _error = error;

  String get message => _message;

  set message(String message) => _message = message;

  FoodDonorRegistration.fromJson(Map<String, dynamic> json) {
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    _error = json['error'];
    _message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._data != null) {
      data['data'] = this._data!.toJson();
    }
    data['error'] = this._error;
    data['message'] = this._message;
    return data;
  }
}

class Data {
  String? _userId = "";

  Data({required String userId}) {
    this._userId = userId;
  }

  String? get userId => _userId;

  set userId(String? userId) => _userId = userId;

  Data.fromJson(Map<String, dynamic> json) {
    _userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this._userId;
    return data;
  }
}
