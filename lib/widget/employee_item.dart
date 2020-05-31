import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/employee_provider.dart';
import '../screens/add_edit_employeeScreen.dart';

class EmployeeItem extends StatelessWidget {
  final int id;
  final String name;
  final String designation;

  const EmployeeItem({this.id, this.name, this.designation});

  String getShortName() {
    String shortName = "";
    shortName = name.substring(0, 1).toUpperCase() + ".";

    int index = name.indexOf(' ');
    if (index > 0 && (index + 2) < name.length) {
      shortName += name.substring(index + 1, index + 2).toUpperCase();
    }
    return shortName;
  }

  Future<void> deleteEmployee(BuildContext context) async {
    final employeeProvider =
        Provider.of<EmployeeProvider>(context, listen: false);
    await employeeProvider.deleteEmployee(id);
  }

  @override
  Widget build(BuildContext context) {
    ScaffoldState scaffold = Scaffold.of(context);
//    Provider.of<EmployeeProvider>(context, listen: false).getEmployees();
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                child: Text(
                  '${getShortName()}',
                  style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(name,
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 20.0,
              )),
          subtitle: Text(designation,
              style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800)),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    print('in employee item: $id');
                    int result = await showDialog(
                      context: context,
                      builder: (BuildContext ctx) => EditEmployeeScreen(
                        chosenEmployeeId: id,
                      ),
                    );
                    if (result != null && result > 0) {
                      scaffold.hideCurrentSnackBar();
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Modified an Employee Profile',
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                      );
                    }
                  },
                  color: Theme.of(context).accentColor,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    bool result = await _showDialog(context);
                    if (result) {
                      scaffold.hideCurrentSnackBar();
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Deleted an Employee',
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                      );
                    }
                  },
                  color: Theme.of(context).errorColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Are you sure'),
        content: Text('Do you want to delete current employee?'),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(_).pop(false);
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () async {
              await deleteEmployee(context);
//              Navigator.of(context).pushReplacementNamed(HomePage.id);
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }
}
