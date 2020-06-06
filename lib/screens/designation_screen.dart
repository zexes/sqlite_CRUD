import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/designation_provider.dart';
import '../screens/add_edit_designationScreen.dart';
import '../widget/designation_item.dart';
import '../widget/app_drawer.dart';

class DesignationScreen extends StatelessWidget {
  static const String id = 'designation_screen';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //no scaffold above
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Designations'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _showDialog(context),
            )
          ],
        ),
        body: FutureBuilder(
            future: Provider.of<DesignationProvider>(context, listen: false)
                .getDesignations(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (dataSnapshot.error != null) {
                // handle error
                return Center(child: Text('An error occurred'));
              } else {
                return Consumer<DesignationProvider>(
                  builder: (_, designationData, __) {
                    final designationList = designationData.designations;
                    return ListView.builder(
                      itemBuilder: (context, index) =>
                          ChangeNotifierProvider.value(
                              value: designationList[index],
                              child: DesignationItem(
                                  id: designationList[index].id,
                                  display: designationList[index].display,
                                  value: designationList[index].value)),
                      itemCount: designationList.length,
                    );
                  },
                );
              }
            }),
        drawer: AppDrawer(),
        floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          onPressed: () => _showDialog(context),
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).accentColor,
        ),
      ),
      onWillPop: () {
        return;
      },
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    dynamic result = await showDialog(
        context: context,
        builder: (BuildContext ctx) => EditDesignationScreen());
    if (result == null) return;
    if (result == -9) {
      addSnack(context, 'Designation Already Exist',
          Theme.of(context).errorColor.withOpacity(0.8));
    } else {
      addSnack(
          context, 'Added new Designation', Theme.of(context).primaryColorDark);
    }
    await Provider.of<DesignationProvider>(context, listen: false)
        .getDesignations();
  }

  void addSnack(BuildContext context, String message, Color color) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
    ));
  }
}
