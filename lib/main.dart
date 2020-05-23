import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite/provider/designation_provider.dart';
import './provider/employee_provider.dart';
import './widget/app_drawer.dart';
import './screens/designation_screen.dart';
import './screens/add_edit_employeeScreen.dart';
import './screens/home_page.dart';
import 'model/Designation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<EmployeeProvider>(
            create: (context) => EmployeeProvider(),
          ),
          FutureProvider<List<Designation>>(
            initialData: [],
            create: (context) => DesignationProvider().getDesignations(),
          ),
        ],
        child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.green,
              accentColor: Colors.purple,
              fontFamily: 'SourceSansPro'),
//      home: ProductOverviewScreen(),
          initialRoute: HomePage.id,
          routes: {
            HomePage.id: (_) => HomePage(),
            EditEmployeeScreen.id: (_) => EditEmployeeScreen(),
            DesignationScreen.id: (_) => DesignationScreen(),
            AppDrawer.id: (_) => AppDrawer()
          },
        ));
  }
}
