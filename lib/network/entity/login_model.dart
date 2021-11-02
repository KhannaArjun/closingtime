class LoginModel
{
  String? _message;
  bool _error = false;
  String? _userId;

  LoginModel({required String message, required bool error, required String userId}) {
    this._message = message;
    this._error = error;
    this._userId = userId;
  }

  String? get message => _message;
  set message(String? message) => _message = message;
  bool get error => _error;
  set error(bool error) => _error = error;
  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;

  LoginModel.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    _error = json['error'];
    _userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this._message;
    data['error'] = this._error;
    data['user_id'] = this._userId;
    return data;
  }
}