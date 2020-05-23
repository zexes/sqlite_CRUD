import 'package:flutter/foundation.dart';
import 'package:sqflite/sqlite_api.dart';
import '../model/Designation.dart';
import '../db/database_helper.dart';

class DesignationProvider with ChangeNotifier {
  Future<Database> database = DatabaseHelper().database;

  Future<int> saveDesignation(Designation designation) async {
    Database db = await database;
    int res = await db.insert("Designation", designation.toMap());
    print('saved new designation');
    return res;
  }

  Future<List<Designation>> getDesignations() async {
    Database db = await database;
    List<Map> designationFromDb =
        await db.rawQuery('SELECT * FROM Designation');
    List<Designation> designations = [];
    for (int i = 0; i < designationFromDb.length; i++) {
      final designationIndex = designationFromDb[i];
      Designation designation = Designation(
        designationIndex["display"],
        designationIndex["value"],
      );
      designation.setUserId(designationIndex["id"]);
      designations.add(designation);
    }
    print('database length: , ${designations.length}');
    return designations;
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
      map['value'] = designationIndex["display_value"];
      listMap.add(map);
    }
    print('database length: , $listMap');

    return listMap;
  }

  Future<Designation> getSingleDesignation(int id) async {
    List<Designation> designations = await getDesignations();
    Designation designation = designations.firstWhere((des) => des.id == id);
    return designation;
  }

  Future<int> deleteDesignation(Designation designation) async {
    Database db = await database;

    int res = await db
        .rawDelete('DELETE FROM Designation WHERE id = ?', [designation.id]);
    return res;
  }

  Future<int> update(Designation designation) async {
    Database db = await database;
    int res = await db.update("Designation", designation.toMap(),
        where: "id = ?", whereArgs: <int>[designation.id]);
    print('updated new Designation');
    return res;
  }
}
