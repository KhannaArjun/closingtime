class FoodDonatedData
{
  late String _foodName;
  late String _foodDesc;
  late String _quantity;
  late String _date;

  FoodDonatedData(this._foodName, this._foodDesc, this._quantity, this._date);

  String get date => _date;

  String get quantity => _quantity;

  String get foodDesc => _foodDesc;

  String get foodName => _foodName;
}