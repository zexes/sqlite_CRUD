import 'package:flutter/foundation.dart';
import 'package:sqflite/sqlite_api.dart';
import '../db/database_helper.dart';
import '../model/employee.dart';

class EmployeeProvider with ChangeNotifier {
  Future<Database> database = DatabaseHelper().database;

  Future<int> saveEmployee(Employee employee) async {
    Database db = await database;
    int res = await db.insert("Employee", employee.toMap());
    print('saved new employee');
    return res;
  }

  Future<List<Employee>> getEmployees() async {
    Database db = await database;
    List<Map> employeesFromDb = await db.rawQuery('SELECT * FROM Employee');
    List<Employee> employees = [];
    for (int i = 0; i < employeesFromDb.length; i++) {
      final employeeIndex = employeesFromDb[i];
      Employee employee = Employee(employeeIndex["name"], employeeIndex["dob"],
          employeeIndex["designation"]);
      employee.setUserId(employeeIndex["id"]);
      employees.add(employee);
    }
    print('database length: , ${employees.length}');
    return employees;
  }

  Future<Employee> getSingleEmployee(int id) async {
    List<Employee> employees = await getEmployees();
    Employee employee = employees.firstWhere((emp) => emp.id == id);
    return employee;
  }

  Future<int> deleteEmployee(Employee employee) async {
    Database db = await database;

    int res =
        await db.rawDelete('DELETE FROM Employee WHERE id = ?', [employee.id]);
    return res;
  }

  Future<int> update(Employee employee) async {
    Database db = await database;
    int res = await db.update("Employee", employee.toMap(),
        where: "id = ?", whereArgs: <int>[employee.id]);
    print('updated new employee');
    return res;
  }
}
