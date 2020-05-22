class Designation {
  int id;
  String _display; // since i did not declare as final
  String _value;

  Designation(this._display, this._value);

  Designation.map(dynamic obj) {
    this._display = obj["display"];
    this._value = obj["value"];
  }

  String get display => _display;

  String get value => _value;

  Map<String, String> toMap() => {"display": _display, "value": _value};

//  Map<String, dynamic> toMap(){
//    Map<String, dynamic> map = Map<String, dynamic>();
//    map["name"] = _name;
//    map["dob"] = _dob;
//    map["designation"] = _designation;
//    return map;}

  void setUserId(int id) {
    this.id = id;
  }
}
