import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqlite_api.dart';
import '../db/database_helper.dart';
import '../model/employee.dart';

class EmployeeProvider with ChangeNotifier {
  Future<Database> database = DatabaseHelper().database;

  List<Employee> _employeesList = [];

  List<Employee> get employees {
    return UnmodifiableListView(_employeesList);
  }

  Future<void> saveEmployee(Employee employee) async {
    Database db = await database;
    int res = await db.insert("Employee", employee.toMap());
    _employeesList.add(employee);
    print('saved new employee');
    notifyListeners();
  }

  Future<void> getEmployees() async {
    Database db = await database;
    List<Map> employeesFromDb = await db.rawQuery('SELECT * FROM Employee');
    List<Employee> employees = [];
    for (int i = 0; i < employeesFromDb.length; i++) {
      final employeeIndex = employeesFromDb[i];
      Employee employee = Employee(employeeIndex["name"], employeeIndex["dob"],
          employeeIndex["designation"]);
      employee.setEmployeeId(employeeIndex["id"]);
      employees.add(employee);
    }
    _employeesList = employees;
    print('database length: , ${employees.length}');
    notifyListeners();
  }

  Future<Employee> getSingleEmployee(int id) async {
    List<Employee> employees = _employeesList;
    Employee employee = employees.firstWhere((emp) => emp.id == id);
    return employee;
  }

  Future<void> deleteEmployee(int id) async {
    Database db = await database;

    int res = await db.rawDelete('DELETE FROM Employee WHERE id = ?', [id]);
    int employeeIndex =
        _employeesList.indexWhere((element) => element.id == id);
    _employeesList.removeAt(employeeIndex);
    notifyListeners();
  }

  Future<void> update(Employee employee) async {
    Database db = await database;
    int index =
        _employeesList.indexWhere((element) => element.id == employee.id);
    _employeesList.removeWhere((element) => element.id == employee.id);
    print('id ${employee.id}');
    int res = await db.update("Employee", employee.toMap(),
        where: "id = ?", whereArgs: <int>[employee.id]);
    print('updated new employee');
    _employeesList.insert(index, employee);
    notifyListeners();
  }
}
