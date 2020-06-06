import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqlite/provider/designation_provider.dart';
import '../widget/app_drawer.dart';
import '../screens/designation_screen.dart';
import '../provider/employee_provider.dart';
import '../widget/employee_item.dart';
import './add_edit_employeeScreen.dart';

enum Options { Add, Designation }

class HomePage extends StatelessWidget {
  static const String id = 'home_page';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('GloboMedRef'),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (Options selectedValue) async {
                if (selectedValue == Options.Add) {
                  _showDialog(context);
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
        body: FutureBuilder(
          future: Provider.of<EmployeeProvider>(context, listen: false)
              .getEmployees(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (dataSnapshot.error != null)
              return Center(
                child: Text('An error Occurred'),
              );
            else
              return Consumer<EmployeeProvider>(
                builder: (_, employeeData, __) {
                  final employeeList = employeeData.employees;
                  return ListView.builder(
                    itemBuilder: (context, index) =>
                        ChangeNotifierProvider.value(
                      value: employeeList[index],
                      child: EmployeeItem(
                          id: employeeList[index].id,
                          name: employeeList[index].name,
                          designation: employeeList[index].designation),
                    ),
                    itemCount: employeeList.length,
                  );
                },
              );
          },
        ),
        drawer: AppDrawer(),
        floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          onPressed: () => _showDialog(context),
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).accentColor,
        ),
      ),
      onWillPop: () => onWillPop(context),
    );
  }

  void _showDialog(BuildContext context) async {
    final totalDesignations =
        Provider.of<DesignationProvider>(context, listen: false).designations;
    if (totalDesignations.length <= 0) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Add designations to Proceed',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    int result = await showDialog(
        context: context,
        builder: (BuildContext context) => EditEmployeeScreen());
    if (result == 0) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Added an Employee',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).accentColor,
          duration: Duration(seconds: 2),
        ),
      );
    }
    await Provider.of<EmployeeProvider>(context, listen: false)
        .getEmployees(); // to populate _employeesList from getEmployees() in order to make available for editing
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
