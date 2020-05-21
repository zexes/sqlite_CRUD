import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/employee.dart';
import '../provider/employee_provider.dart';
import '../widget/employee_item.dart';
import './add_edit_employeeScreen.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home_page';

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Employee>>(
      initialData: [],
      create: (context) => EmployeeProvider().getEmployees(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('GloboMedRef'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.group_add,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext ctx) => EditEmployeeScreen());
              },
            ),
          ],
        ),
        body: Consumer<List<Employee>>(
          builder: (_, employees, __) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final employeeIndex = employees[index];
                return EmployeeItem(
                    id: employeeIndex.id,
                    name: employeeIndex.name,
                    designation: employeeIndex.designation);
              },
              itemCount: employees.length,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext ctx) => EditEmployeeScreen()),
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
