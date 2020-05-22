import 'package:flutter/material.dart';
import 'package:sqlite/model/Designation.dart';
import 'package:sqlite/provider/designation_provider.dart';
import 'package:sqlite/screens/designation_screen.dart';
import '../model/employee.dart';
import '../provider/employee_provider.dart';
import '../screens/add_edit_employeeScreen.dart';
import '../screens/home_page.dart';

class DesignationItem extends StatelessWidget {
  final int id;
  final String display;
  final String displayValue;

  const DesignationItem({this.id, this.display, this.displayValue});

  Future<void> deleteDesignation() async {
    var db = DesignationProvider();
    Designation designation = await db.getSingleDesignation(id);
    await db.deleteDesignation(designation);
  }

  Future<void> editDesignation(Designation designation) async {
    var db = DesignationProvider();
    db.update(designation);
  }

  @override
  Widget build(BuildContext context) {
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
                  display.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(display,
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 20.0,
              )),
          subtitle: Text(displayValue,
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext ctx) => EditEmployeeScreen(
                        chosenEmployeeId: id,
                      ),
                    );
                  },
                  color: Theme.of(context).accentColor,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    return _showDialog(context);
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
        content: Text('Do you want to delete Designation?'),
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
              await deleteDesignation();
              Navigator.of(context).pushReplacementNamed(DesignationScreen.id);
            },
          )
        ],
      ),
    );
  }
}
