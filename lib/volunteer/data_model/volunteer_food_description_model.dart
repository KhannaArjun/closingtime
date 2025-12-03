class VolunteerFoodDescriptionModel {
  VolunteerFoodDescriptionModel({
    required this.data,
    required this.error,
    required this.message,
  });

  late final VolunteerFoodDescriptionModelData data;
  late final bool error;
  late final String message;

  VolunteerFoodDescriptionModel.fromJson(Map<String, dynamic> json) {
    data = VolunteerFoodDescriptionModelData.fromJson(json['data']);
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData['data'] = data.toJson();
    jsonData['error'] = error;
    jsonData['message'] = message;
    return jsonData;
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

  VolunteerFoodDescriptionModelData.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '';
    donorAddress = json['donor_address'] ?? '';
    donorBusinessName = json['donor_business_name'] ?? '';
    donorContactNumber = json['donor_contact_number'] ?? '';
    donorLat = double.tryParse(json['donor_lat']?.toString() ?? '0') ?? 0.0;
    donorLng = double.tryParse(json['donor_lng']?.toString() ?? '0') ?? 0.0;
    donorName = json['donor_name'] ?? '';
    recipientAddress = json['recipient_address'] ?? '';
    recipientBusinessName = json['recipient_business_name'] ?? '';
    recipientContactNumber = json['recipient_contact_number'] ?? '';
    recipientLat = double.tryParse(json['recipient_lat']?.toString() ?? '0') ?? 0.0;
    recipientLng = double.tryParse(json['recipient_lng']?.toString() ?? '0') ?? 0.0;
    recipientName = json['recipient_name'] ?? '';
    distance = json['distance'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['donor_address'] = donorAddress;
    data['donor_business_name'] = donorBusinessName;
    data['donor_contact_number'] = donorContactNumber;
    data['donor_lat'] = donorLat;
    data['donor_lng'] = donorLng;
    data['donor_name'] = donorName;
    data['recipient_address'] = recipientAddress;
    data['recipient_business_name'] = recipientBusinessName;
    data['recipient_contact_number'] = recipientContactNumber;
    data['recipient_lat'] = recipientLat;
    data['recipient_lng'] = recipientLng;
    data['recipient_name'] = recipientName;
    data['distance'] = distance;
    return data;
  }
}
