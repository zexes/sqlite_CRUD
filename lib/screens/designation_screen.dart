import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/add_edit_designationScreen.dart';
import '../provider/designation_provider.dart';
import '../widget/designation_item.dart';
import '../model/Designation.dart';
import '../widget/app_drawer.dart';

class DesignationScreen extends StatelessWidget {
  static const String id = 'designation_screen';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: FutureProvider<List<Designation>>(
        initialData: [],
        create: (context) => DesignationProvider().getDesignations(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Designations'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) => EditDesignationScreen());
                },
              )
            ],
          ),
          body: Consumer<List<Designation>>(
            builder: (_, designations, __) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final designationIndex = designations[index];
                  return DesignationItem(
                      id: designationIndex.id,
                      display: designationIndex.display,
                      value: designationIndex.value);
                },
                itemCount: designations.length,
              );
            },
          ),
          drawer: AppDrawer(),
          floatingActionButton: FloatingActionButton(
            elevation: 5.0,
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext ctx) => EditDesignationScreen()),
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
            splashColor: Theme.of(context).accentColor,
          ),
        ),
      ),
      onWillPop: () {
        return;
      },
    );
  }
}
