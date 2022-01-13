class MilesModel
{
  String _item = "";
  bool _isSelected = false;


  MilesModel(this._item, this._isSelected);

  String get getItem => _item;

   item(String value) {
    _item = value;
  }

  bool get selected => _isSelected;

  isSelected(bool value) {
    _isSelected = value;
  }

}