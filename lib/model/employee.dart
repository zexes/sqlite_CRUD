class Employee {
  int id;
  String _name; // since i did not declare as final
  int _dob;
  String _designation;

  Employee(this._name, this._dob, this._designation);

  Employee.map(dynamic obj) {
    this._name = obj["name"];
    this._dob = obj["dob"];
    this._designation = obj["designation"];
  }

  String get name => _name;

  int get dob => _dob;

  String get designation => _designation;

  Map<String, dynamic> toMap() =>
      {"name": _name, "dob": _dob, "designation": _designation};

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
