import 'package:flutter/material.dart';
import 'package:sqlite/screens/designation_screen.dart';
import 'package:sqlite/screens/home_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Employee'),
            automaticallyImplyLeading: false, // not to add back button
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Employees'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomePage.id);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Designation'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(DesignationScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
