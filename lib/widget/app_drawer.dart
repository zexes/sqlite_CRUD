import 'package:flutter/material.dart';
import '../screens/designation_screen.dart';
import '../screens/home_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              'Hello Employee',
              style: TextStyle(fontSize: 32),
            ),
            automaticallyImplyLeading: false, // not to add back button
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.people,
              size: 40.0,
              color: Theme.of(context).primaryColorDark,
            ),
            title: Text(
              'Employees',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomePage.id);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.description,
              size: 40.0,
              color: Theme.of(context).primaryColorDark,
            ),
            title: Text('Designation',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 23,
                )),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(DesignationScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
