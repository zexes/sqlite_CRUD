import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/designation_screen.dart';
import '../screens/home_page.dart';

class AppDrawer extends StatelessWidget {
  static const String id = 'app_drawer';

  final txtStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 21);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              'Hello Employee',
              style: TextStyle(fontSize: 30),
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
              style: txtStyle,
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
            title: Text(
              'Designation',
              style: txtStyle,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(DesignationScreen.id);
            },
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              size: 40.0,
              color: Theme.of(context).primaryColorDark,
            ),
            title: Text('Logout', style: txtStyle),
            onTap: () {
              HomePage().onWillPop(context);
            },
          ),
        ],
      ),
    );
  }
}
