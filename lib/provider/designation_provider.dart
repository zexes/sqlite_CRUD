import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqlite_api.dart';
import '../model/Designation.dart';
import '../db/database_helper.dart';

class DesignationProvider with ChangeNotifier {
  Future<Database> database = DatabaseHelper().database;

  List<Designation> _designationList = [];

  List<Designation> get designations {
    print(_designationList.toString());
    return UnmodifiableListView(_designationList);
  }

  Future<void> saveDesignation(Designation designation) async {
    Database db = await database;
    int res = await db.insert("Designation", designation.toMap());
    _designationList.add(designation);
    print('saved new designation');
    notifyListeners();
  }

  Future<void> getDesignations() async {
    Database db = await database;
    List<Map> designationFromDb =
        await db.rawQuery('SELECT * FROM Designation');
    List<Designation> designations = [];
    for (int i = 0; i < designationFromDb.length; i++) {
      final designationIndex = designationFromDb[i];
      Designation designation =
          Designation(designationIndex["display"], designationIndex["value"]);
      designation.setDesignationId(designationIndex["id"]);
      designations.add(designation);
    }
    _designationList = designations;
    print('database length: , ${designations.length}');
    notifyListeners();
  }

  Future<List<Map<String, String>>> getDesignationsMap() async {
    List<Map<String, String>> listMap = [];
    Database db = await database;
    List<Map> designationFromDb =
        await db.rawQuery('SELECT * FROM Designation');
    for (int i = 0; i < designationFromDb.length; i++) {
      final designationIndex = designationFromDb[i];
      Map<String, String> map = {};
      map['display'] = designationIndex["display"];
      map['value'] = designationIndex["value"];
      listMap.add(map);
    }
    print('database length: , $listMap');

    return listMap;
  }

  Future<Designation> getSingleDesignation(int id) async {
    List<Designation> designations = _designationList;
    Designation designation = designations.firstWhere((des) => des.id == id);
    return designation;
  }

  Future<void> deleteDesignation(int id) async {
    Database db = await database;

    int res = await db.rawDelete('DELETE FROM Designation WHERE id = ?', [id]);
    int employeeIndex =
        _designationList.indexWhere((element) => element.id == id);
    _designationList.removeAt(employeeIndex);
    notifyListeners();
  }

  Future<void> update(Designation designation) async {
    Database db = await database;
    int index =
        _designationList.indexWhere((element) => element.id == designation.id);
    _designationList.removeWhere((element) => element.id == designation.id);
    int res = await db.update("Designation", designation.toMap(),
        where: "id = ?", whereArgs: <int>[designation.id]);
    print('updated new Designation');
    _designationList.insert(index, designation);
    notifyListeners();
  }
}
