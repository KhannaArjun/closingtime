class LocationDetailsModel
{
  String _address = "";
  double _lat = 0.0, _lng = 0.0;
  String _placeId = "";

  LocationDetailsModel(this._address, this._lat, this._lng, this._placeId);

  String get placeId => _placeId;

  get lng => _lng;

  double get lat => _lat;

  String get address => _address;
}