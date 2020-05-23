import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../widget/app_drawer.dart';
import '../screens/designation_screen.dart';
import '../model/employee.dart';
import '../provider/employee_provider.dart';
import '../widget/employee_item.dart';
import './add_edit_employeeScreen.dart';

enum Options { Add, Designation }

class HomePage extends StatelessWidget {
  static const String id = 'home_page';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('GloboMedRef'),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (Options selectedValue) async {
                bool result;
                if (selectedValue == Options.Add) {
                  result = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext ctx) => EditEmployeeScreen());
                } else {
                  Navigator.of(context)
                      .pushReplacementNamed(DesignationScreen.id);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Add Employee'),
                  value: Options.Add,
                ),
                PopupMenuItem(
                  child: Text('Designation Screen'),
                  value: Options.Designation,
                )
              ],
            )
          ],
        ),
        body: Consumer<EmployeeProvider>(
          builder: (_, empProvider, __) {
            return FutureBuilder<List<Employee>>(
              future: empProvider.getEmployees(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColorDark,
                  ));
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final employeeIndex = snapshot.data[index];
                    return EmployeeItem(
                        id: employeeIndex.id,
                        name: employeeIndex.name,
                        designation: employeeIndex.designation);
                  },
                  itemCount: snapshot.data.length,
                );
              },
            );
          },
        ),
        drawer: AppDrawer(),
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
      onWillPop: () => onWillPop(context),
    );
  }

  Future<bool> onWillPop(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
//                onPressed: () => Navigator.of(context).pop(true),
//                onPressed: () => SystemNavigator.pop(),
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
