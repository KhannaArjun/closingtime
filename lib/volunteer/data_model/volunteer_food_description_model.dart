class VolunteerFoodDescriptionModel {
  VolunteerFoodDescriptionModel({
    required this.data,
    required this.error,
    required this.message,
  });
  late final VolunteerFoodDescriptionModelData data;
  late final bool error;
  late final String message;

  VolunteerFoodDescriptionModel.fromJson(Map<String, dynamic> json){
    data = VolunteerFoodDescriptionModelData.fromJson(json['data']);
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    _data['error'] = error;
    _data['message'] = message;
    return _data;
  }
}

class VolunteerFoodDescriptionModelData {
  VolunteerFoodDescriptionModelData({
    required this.code,
    required this.donorAddress,
    required this.donorBusinessName,
    required this.donorContactNumber,
    required this.donorLat,
    required this.donorLng,
    required this.donorName,
    required this.recipientAddress,
    required this.recipientBusinessName,
    required this.recipientContactNumber,
    required this.recipientLat,
    required this.recipientLng,
    required this.recipientName,
    required this.distance,
  });
  late final String code;
  late final String donorAddress;
  late final String donorBusinessName;
  late final String donorContactNumber;
  late final double donorLat;
  late final double donorLng;
  late final String donorName;
  late final String recipientAddress;
  late final String recipientBusinessName;
  late final String recipientContactNumber;
  late final double recipientLat;
  late final double recipientLng;
  late final String recipientName;
  late final String distance;

  VolunteerFoodDescriptionModelData.fromJson(Map<String, dynamic> json){
    code = json['code'];
    donorAddress = json['donor_address'];
    donorBusinessName = json['donor_business_name'];
    donorContactNumber = json['donor_contact_number'];
    donorLat = json['donor_lat'];
    donorLng = json['donor_lng'];
    donorName = json['donor_name'];
    recipientAddress = json['recipient_address'];
    recipientBusinessName = json['recipient_business_name'];
    recipientContactNumber = json['recipient_contact_number'];
    recipientLat = json['recipient_lat'];
    recipientLng = json['recipient_lng'];
    recipientName = json['recipient_name'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['donor_address'] = donorAddress;
    _data['donor_business_name'] = donorBusinessName;
    _data['donor_contact_number'] = donorContactNumber;
    _data['donor_lat'] = donorLat;
    _data['donor_lng'] = donorLng;
    _data['donor_name'] = donorName;
    _data['recipient_address'] = recipientAddress;
    _data['recipient_business_name'] = recipientBusinessName;
    _data['recipient_contact_number'] = recipientContactNumber;
    _data['recipient_lat'] = recipientLat;
    _data['recipient_lng'] = recipientLng;
    _data['recipient_name'] = recipientName;
    _data['distance'] = distance;
    return _data;
  }
}